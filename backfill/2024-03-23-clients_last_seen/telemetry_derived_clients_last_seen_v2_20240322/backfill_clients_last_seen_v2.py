# Based on https://github.com/mozilla/bigquery-etl/blob/main/sql/moz-fx-data-shared-prod/telemetry_derived/clients_last_seen_v2/query.sql
import os
import subprocess
from argparse import ArgumentParser
from multiprocessing.pool import ThreadPool
from functools import partial

import click
import tempfile
import yaml
from google.api_core.exceptions import NotFound
from google.cloud import bigquery

from bigquery_etl.backfill.date_range import BackfillDateRange, get_backfill_partition
from bigquery_etl.metadata.parse_metadata import PartitionType

this_path = os.path.abspath(__file__)
this_dir = os.path.dirname(os.path.abspath(__file__))


PARTITION_QUERY = """
    WITH _current AS (
      SELECT
        CAST(TRUE AS INT64) AS days_seen_bits,
        CAST(active_hours_sum > 0 AS INT64) & CAST(
            COALESCE(
            scalar_parent_browser_engagement_total_uri_count_normal_and_private_mode_sum,
            scalar_parent_browser_engagement_total_uri_count_sum
          ) > 0 AS INT64
        ) AS days_active_bits,
        CAST(
          COALESCE(
            scalar_parent_browser_engagement_total_uri_count_normal_and_private_mode_sum,
            scalar_parent_browser_engagement_total_uri_count_sum
          ) >= 1 AS INT64
        ) AS days_visited_1_uri_bits,
        CAST(
          COALESCE(
            scalar_parent_browser_engagement_total_uri_count_normal_and_private_mode_sum,
            scalar_parent_browser_engagement_total_uri_count_sum
          ) >= 5 AS INT64
        ) AS days_visited_5_uri_bits,
        CAST(
          COALESCE(
            scalar_parent_browser_engagement_total_uri_count_normal_and_private_mode_sum,
            scalar_parent_browser_engagement_total_uri_count_sum
          ) >= 10 AS INT64
        ) AS days_visited_10_uri_bits,
        CAST(active_hours_sum >= 0.011 AS INT64) AS days_had_8_active_ticks_bits,
        CAST(devtools_toolbox_opened_count_sum > 0 AS INT64) AS days_opened_dev_tools_bits,
        CAST(active_hours_sum > 0 AS INT64) AS days_interacted_bits,
        CAST(
          scalar_parent_browser_engagement_total_uri_count_sum >= 1 AS INT64
        ) AS days_visited_1_uri_normal_mode_bits,
        -- This field is only available after version 84, see the definition in clients_daily_v6 view
        CAST(
          IF(
            mozfun.norm.extract_version(app_display_version, 'major') < 84,
            NULL,
            scalar_parent_browser_engagement_total_uri_count_normal_and_private_mode_sum - COALESCE(
              scalar_parent_browser_engagement_total_uri_count_sum,
              0
            )
          ) >= 1 AS INT64
        ) AS days_visited_1_uri_private_mode_bits,
        -- We only trust profile_date if it is within one week of the ping submission,
        -- so we ignore any value more than seven days old.
        udf.days_since_created_profile_as_28_bits(
          DATE_DIFF(submission_date, SAFE.PARSE_DATE("%F", SUBSTR(profile_creation_date, 0, 10)), DAY)
        ) AS days_created_profile_bits,
        -- Experiments are an array, so we keep track of a usage bit pattern per experiment.
        ARRAY(
          SELECT AS STRUCT
            key AS experiment,
            value AS branch,
            1 AS bits
          FROM
            UNNEST(experiments)
        ) AS days_seen_in_experiment,
        * EXCEPT (submission_date)
    FROM
        `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6`
    WHERE
        submission_date = DATE('{submission_date}')
        AND sample_id = {sample_id}
    ),
    _previous AS (
      SELECT
        days_seen_bits,
        days_active_bits,
        days_visited_1_uri_bits,
        days_visited_5_uri_bits,
        days_visited_10_uri_bits,
        days_had_8_active_ticks_bits,
        days_opened_dev_tools_bits,
        days_interacted_bits,
        days_visited_1_uri_normal_mode_bits,
        days_visited_1_uri_private_mode_bits,
        days_created_profile_bits,
        days_seen_in_experiment,
        * EXCEPT (
          days_seen_bits,
          days_active_bits,
          days_visited_1_uri_bits,
          days_visited_5_uri_bits,
          days_visited_10_uri_bits,
          days_had_8_active_ticks_bits,
          days_opened_dev_tools_bits,
          days_interacted_bits,
          days_visited_1_uri_normal_mode_bits,
          days_visited_1_uri_private_mode_bits,
          days_created_profile_bits,
          days_seen_in_experiment,
          submission_date,
          first_seen_date,
          second_seen_date
        )
      FROM
        `{full_table_id}`
      WHERE
        submission_date = DATE_SUB(DATE('{submission_date}'), INTERVAL 1 DAY)
        AND sample_id = {sample_id}
        -- Filter out rows from yesterday that have now fallen outside the 28-day window.
        AND udf.shift_28_bits_one_day(days_seen_bits) > 0
    )
    --
    SELECT
      DATE('{submission_date}') AS submission_date,
      IF(cfs.first_seen_date > DATE('{submission_date}'), NULL, cfs.first_seen_date) AS first_seen_date,
      IF(cfs.second_seen_date > DATE('{submission_date}'), NULL, cfs.second_seen_date) AS second_seen_date,
      IF(_current.client_id IS NOT NULL, _current, _previous).* REPLACE (
        udf.combine_adjacent_days_28_bits(
          _previous.days_seen_bits,
          _current.days_seen_bits
        ) AS days_seen_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_active_bits,
          _current.days_active_bits
        ) AS days_active_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_visited_1_uri_bits,
          _current.days_visited_1_uri_bits
        ) AS days_visited_1_uri_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_visited_5_uri_bits,
          _current.days_visited_5_uri_bits
        ) AS days_visited_5_uri_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_visited_10_uri_bits,
          _current.days_visited_10_uri_bits
        ) AS days_visited_10_uri_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_had_8_active_ticks_bits,
          _current.days_had_8_active_ticks_bits
        ) AS days_had_8_active_ticks_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_opened_dev_tools_bits,
          _current.days_opened_dev_tools_bits
        ) AS days_opened_dev_tools_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_interacted_bits,
          _current.days_interacted_bits
        ) AS days_interacted_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_visited_1_uri_normal_mode_bits,
          _current.days_visited_1_uri_normal_mode_bits
        ) AS days_visited_1_uri_normal_mode_bits,
        udf.combine_adjacent_days_28_bits(
          _previous.days_visited_1_uri_private_mode_bits,
          _current.days_visited_1_uri_private_mode_bits
        ) AS days_visited_1_uri_private_mode_bits,
        udf.coalesce_adjacent_days_28_bits(
          _previous.days_created_profile_bits,
          _current.days_created_profile_bits
        ) AS days_created_profile_bits,
        udf.combine_experiment_days(
          _previous.days_seen_in_experiment,
          _current.days_seen_in_experiment
        ) AS days_seen_in_experiment
      )
    FROM
      _current
    FULL JOIN
      _previous
      USING (client_id)
    LEFT JOIN
      `moz-fx-data-shared-prod.telemetry_derived.clients_first_seen_v2` AS cfs
      USING (client_id)
"""

CREATE_TABLE_QUERY = """
    CREATE OR REPLACE TABLE
      `{project_id}.{dataset}.{table}_{sample_id}`
    PARTITION BY
        submission_date
    CLUSTER BY
        normalized_channel,
        sample_id
    AS
    SELECT
        *
    FROM
        `{project_id}.{dataset}.{table}`
    WHERE
        FALSE;
"""

parser = ArgumentParser()
parser.add_argument(
    "--project_id",
    "--project-id",
    default="moz-fx-data-shared-prod",
    help="ID of the project in which to find tables",
)
parser.add_argument(
    "--dataset",
    default="backfills_staging_derived",
    help="Dataset name to create clients_first_seen_table in",
)
parser.add_argument(
    "--table",
    default="telemetry_derived_clients_last_seen_v2_20230322",
    help="Name of the destination table to be created",
)
parser.add_argument(
    "--parallelism",
    "-p",
    default=10,
    help="Number of threads run in parallel",
)
parser.add_argument(
  "--dry_run",
  default=False,
  help="Issue a dry run"
)
parser.add_argument(
    "--start_date",
    "--start-date",
    "-s",
    help="First date to be backfilled",
    type=click.DateTime(formats=["%Y-%m-%d"]),
    default='2016-03-12'
)
parser.add_argument(
    "--end_date",
    "--end-date",
    "-e",
    help="Last date to be backfilled",
    type=click.DateTime(formats=["%Y-%m-%d"]),
    # default='2024-03-28',
    default='2016-03-15',
)


def get_bigquery_schema(schema_yaml):
    bigquery_schema = []
    for item in schema_yaml:
        if item['type'] == 'RECORD':
            fields = []
            for field in item['fields']:
                fields.append({
                    'mode': field['mode'],
                    'type': field['type'],
                    'name': field['name'],
                })
            bigquery_schema.append({
                'mode': item['mode'],
                'type': item['type'],
                'name': item['name'],
                'fields': fields
            })
        else:
            bigquery_schema.append({
                'mode': item['mode'],
                'type': item['type'],
                'name': item['name'],
            })
    return bigquery_schema


def _backfill_staging_table(client, job_config, project_id, dataset, destination_table, bigquery_schema, submission_date, sample_id):
    """Backfill for a submission_date, sample_id combination."""
    full_table_id = f"{project_id}.{dataset}.{destination_table}_{sample_id}"
    try:
        table = client.get_table(full_table_id)
    except NotFound:
        table = bigquery.Table(full_table_id)
        table.schema = bigquery_schema
        table.time_partitioning = bigquery.TimePartitioning(
            type_=bigquery.TimePartitioningType.DAY,
            field='submission_date'
        )
        table.clustering_fields =['normalized_channel', 'sample_id']

    if not table.created:
        client.create_table(table)
        click.echo(f"Destination table {full_table_id} created.")
    else:
        client.update_table(table, ["schema"])

    if (
            partition := get_backfill_partition(
                submission_date,
                "submission_date",
                0,
                PartitionType.DAY
            )
        ) is not None:
        dest_table = f"{destination_table}_{sample_id}${partition}"

    print(f"Running a backfill for sample_id={sample_id} to {dest_table}")

    arguments = (
            ['query', '--use_legacy_sql=false', '--replace', '--project_id=moz-fx-data-shared-prod',
             '--format=none']
            + [f'--dataset_id={dataset}']
            + [f'--destination_table={dest_table}']
    )

    with tempfile.NamedTemporaryFile(mode="w+") as query_stream:
        query_stream.write(
            PARTITION_QUERY.format(submission_date=submission_date, sample_id=sample_id, full_table_id=full_table_id)
        )
        query_stream.seek(0)
        subprocess.check_call(["bq"] + arguments, stdin=query_stream)


def main():
    """Backfill table `backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20240322` in parallel."""
    args = parser.parse_args()

    client = bigquery.Client(args.project_id)

    if args.dry_run:
      print("Do a dry run")
      job_config = bigquery.QueryJobConfig(dry_run=True, use_query_cache=False)
    else:
      job_config = bigquery.QueryJobConfig(dry_run=False, use_query_cache=False)

    date_range = BackfillDateRange(
        args.start_date,
        args.end_date,
        range_type= PartitionType.DAY,
    )
    print(args.end_date)

    schema_file_path = os.path.join(this_dir, "schema.yaml")
    with open(schema_file_path, 'r') as yaml_file:
        schema_yaml = yaml.safe_load(yaml_file)

    bigquery_schema = get_bigquery_schema(schema_yaml)

    for backfill_date in date_range:
        with ThreadPool(args.parallelism) as pool:
            pool.map(
                partial(
                    _backfill_staging_table,
                    client, job_config, args.project_id, args.dataset, args.table, bigquery_schema, backfill_date),
                    list(range(0, 5)
                         )
            )

if __name__ == "__main__":
    main()

# Based on https://github.com/mozilla/bigquery-etl/blob/main/sql/moz-fx-data-shared-prod/telemetry_derived/clients_first_seen_v1/init.sql

from argparse import ArgumentParser
from multiprocessing.pool import ThreadPool
from functools import partial

from google.cloud import bigquery

CREATE_TABLE_QUERY = """
    CREATE OR REPLACE TABLE
      {dataset}.{table}
    PARTITION BY
        first_seen_date
    CLUSTER BY
        normalized_channel,
        sample_id
    AS
    SELECT
        CAST(NULL AS DATE) AS first_seen_date,
        CAST(NULL AS DATE) AS second_seen_date,
        cd.* EXCEPT (submission_date)
    FROM
        `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6` AS cd
    WHERE
        FALSE;
"""

PARTITON_QUERY = """
  CREATE OR REPLACE TABLE `moz-fx-data-shared-prod.tmp.clients_first_seen_dates_{sample_id}`
  PARTITION BY
    first_seen_date
  AS
  WITH base AS (
    SELECT
      client_id,
      ARRAY_AGG(submission_date ORDER BY submission_date) AS dates_seen,
    FROM
      `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6`
    WHERE
      submission_date >= DATE('2010-01-01')
      AND sample_id = {sample_id}
    GROUP BY
      client_id
  )
  SELECT
    client_id,
    IF(ARRAY_LENGTH(dates_seen) > 0, dates_seen[OFFSET(0)], NULL) AS first_seen_date,
    IF(ARRAY_LENGTH(dates_seen) > 1, dates_seen[OFFSET(1)], NULL) AS second_seen_date,
  FROM
    base;
  INSERT
    {dataset}.{table}
  SELECT
    cfsd.first_seen_date,
    cfsd.second_seen_date,
    cd.* EXCEPT (submission_date)
  FROM
    telemetry_derived.clients_daily_v6 AS cd
  LEFT JOIN
    tmp.clients_first_seen_dates_{sample_id} AS cfsd
  ON
    (cd.submission_date = cfsd.first_seen_date AND cd.client_id = cfsd.client_id)
  WHERE
    cfsd.client_id IS NOT NULL
    AND cd.submission_date >= DATE('2010-01-01')
    AND sample_id = {sample_id};
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
    default="analysis",
    help="Dataset name to create clients_first_seen_table in",
)
parser.add_argument(
    "--table",
    default="ascholtz_clients_first_seen_v1",
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

def _create_temp_table(client, job_config, dataset, table, sample_id):
    """Create temporary table for sample_id."""
    print(f"Create temporary table for sample_id={sample_id}")
    print(PARTITON_QUERY.format(sample_id=sample_id, dataset=dataset, table=table))
    client.query(
      PARTITON_QUERY.format(sample_id=sample_id, dataset=dataset, table=table),
      job_config=job_config
    ).result()

def main():
    """Backfill clients_first_seen_v1 in parallel."""
    args = parser.parse_args()

    client = bigquery.Client(args.project_id)

    if args.dry_run:
      print("Do a dry run")
      job_config = bigquery.QueryJobConfig(dry_run=True, use_query_cache=False)
    else:
      job_config = bigquery.QueryJobConfig(dry_run=False, use_query_cache=False)


    # create the destination table
    client.query(
        CREATE_TABLE_QUERY.format(dataset=args.dataset, table=args.table),
        job_config=job_config
    ).result()

    with ThreadPool(args.parallelism) as pool:
        # create a temporary table for each sample_id
        pool.map(partial(_create_temp_table, client, job_config, args.dataset, args.table), list(range(0, 2)))

if __name__ == "__main__":
    main()

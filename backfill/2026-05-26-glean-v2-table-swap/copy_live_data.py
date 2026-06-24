import argparse
from datetime import date

from google.cloud import bigquery

from bigquery_etl.format_sql.formatter import reformat
from bigquery_etl.schema import generate_compatible_select_expression

backfill_project = "moz-fx-data-backfill-1"

# Destination shared-prod project and the backfill dataset suffix per environment.
ENVIRONMENTS = {
    "stage": ("moz-fx-data-shar-nonprod-efed", "stage"),
    "prod": ("moz-fx-data-shared-prod", "prod"),
}

tables = [
    ("org_mozilla_fennec_aurora_live", "adjust_attribution_v1"),
    ("org_mozilla_fennec_aurora_live", "captcha_detection_v1"),
    ("org_mozilla_fennec_aurora_live", "first_session_v1"),
    ("org_mozilla_fennec_aurora_live", "health_v1"),
    ("org_mozilla_fennec_aurora_live", "metrics_v1"),
    ("org_mozilla_fennec_aurora_live", "sync_v1"),
    ("org_mozilla_fenix_nightly_live", "adjust_attribution_v1"),
    ("org_mozilla_fenix_nightly_live", "captcha_detection_v1"),
    ("org_mozilla_fenix_nightly_live", "first_session_v1"),
    ("org_mozilla_fenix_nightly_live", "health_v1"),
    ("org_mozilla_fenix_nightly_live", "metrics_v1"),
    ("org_mozilla_fenix_nightly_live", "sync_v1"),
]

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--env", choices=ENVIRONMENTS, required=True)
parser.add_argument(
    "--submission-date",
    type=date.fromisoformat,
    default=date.today(),
    help="Partition to copy (YYYY-MM-DD). Defaults to today (UTC).",
)
parser.add_argument(
    "--dry-run",
    action="store_true",
    help="Validate the query without writing.",
)
args = parser.parse_args()

destination_project, backup_suffix = ENVIRONMENTS[args.env]
submission_date = args.submission_date

client = bigquery.Client()

for base_dataset, base_table in tables:
    backup_table = f"{backfill_project}.{base_dataset}_{backup_suffix}.{base_table}"
    destination_table = f"{destination_project}.{base_dataset}.{base_table}"
    select_expr = generate_compatible_select_expression(client, backup_table, destination_table)

    job = client.query(
        reformat(
            f"""
            SELECT {select_expr}
            FROM {backup_table}
            WHERE DATE(submission_timestamp) = "{submission_date.isoformat()}"
            """
        ),
        job_config=bigquery.QueryJobConfig(
            dry_run=args.dry_run,
            destination=f"{destination_table}${submission_date.strftime('%Y%m%d')}",
            write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        )
    )

    print(f"{job.job_id}: {backup_table} -> {destination_table}")

    if not args.dry_run:
        job.result()

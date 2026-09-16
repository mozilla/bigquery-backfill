import subprocess
from datetime import date

from backfill_config import BACKFILL_PROJECT

# All Glean server event pings contain a single event, which allows the UPDATE statement to be a bit simpler.
UPDATE_QUERY_TEMPLATE = """
UPDATE `{table_id}`
SET events = ARRAY(SELECT AS STRUCT events[0].* REPLACE (0 AS `timestamp`))
WHERE DATE(submission_timestamp) BETWEEN @start_date AND @end_date
  AND events[0].timestamp > 0
"""


def fix_events(table_id: str, start_date: date, end_date: date) -> None:
    update_query = UPDATE_QUERY_TEMPLATE.format(table_id=table_id)
    print(f"Fixing {table_id} partitions from {start_date} to {end_date}...")
    command = [
        "bq",
        "query",
        f"--project_id={BACKFILL_PROJECT}",
        "--use_legacy_sql=false",
        f"--parameter=start_date:DATE:{start_date}",
        f"--parameter=end_date:DATE:{end_date}"
    ]
    subprocess.run(command, input=update_query, text=True, check=True)

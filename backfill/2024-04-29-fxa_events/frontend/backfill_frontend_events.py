import subprocess
import concurrent.futures
from datetime import datetime, timedelta

start_date = datetime.strptime('2024-01-01', '%Y-%m-%d')
end_date = datetime.strptime('2024-04-17', '%Y-%m-%d')
# TODO full backfill to 2024-04-17, add missing events from then up to May 28 (inclusive)
max_jobs = 10

# Define the command to be run
def do_job(current_date):
    current_partition = current_date.strftime('%Y%m%d')
    current_date_str = current_date.strftime('%Y-%m-%d')

    dest_table = f"akomar_accounts_frontend_events_v1${current_partition}"

    arguments = (
            ['query', '--use_legacy_sql=false', '--replace', '--project_id=moz-fx-data-shared-prod',
             '--format=none', f'--parameter=submission_date:DATE:{current_date_str}']
            + [f'--dataset_id=mozdata:analysis']
            + [f'--destination_table={dest_table}']
    )

    print(f"Running backfill to {dest_table}")

    with open('convert_frontend.sql', 'r') as file:
        subprocess.check_call(["bq"] + arguments, stdin=file)


# Create a list of dates in the range
dates = [start_date + timedelta(days=x) for x in range(0, (end_date-start_date).days + 1)]

# Use a ThreadPoolExecutor to run the commands in parallel
with concurrent.futures.ThreadPoolExecutor(max_workers=max_jobs) as executor:
    executor.map(do_job, dates)

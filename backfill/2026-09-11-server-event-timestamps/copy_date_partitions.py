import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import date, timedelta

from backfill_config import BACKFILL_PROJECT


def copy_date_partition(from_table: str, to_table: str, partition_date: date) -> None:
    partition_id = partition_date.strftime("%Y%m%d")
    command = [
        "bq",
        "cp",
        f"--project_id={BACKFILL_PROJECT}",
        "--force",
        "--headless",
        "--quiet",
        f"{from_table}${partition_id}",
        f"{to_table}${partition_id}"
    ]
    subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)


class CancellingThreadPoolExecutor(ThreadPoolExecutor):
    """Discards queued work on exit."""
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.shutdown(wait=True, cancel_futures=True)
        return False


def copy_date_partitions(from_table: str, to_table: str, start_date: date, end_date: date) -> None:
    num_partitions = (end_date - start_date).days + 1
    partition_dates = [
        start_date + timedelta(days=partition_offset)
        for partition_offset in range(num_partitions)
    ]

    print(f"Copying {num_partitions} partitions from {from_table} to {to_table}, between {start_date} and {end_date}...")
    num_partitions_copied = 0
    failed_partition_dates = []
    consecutive_failed_partitions = 0
    try:
        # Parallelize the partition copy operations, but try to stay under BigQuery's limit
        # of 50 table metadata update operations per 10 seconds for partitioned tables.
        with CancellingThreadPoolExecutor(max_workers=5) as pool:
            futures_for_partition_dates = {
                pool.submit(copy_date_partition, from_table, to_table, partition_date): partition_date
                for partition_date in partition_dates
            }
            for future in as_completed(futures_for_partition_dates.keys()):
                partition_date = futures_for_partition_dates[future]
                try:
                    future.result()
                    print(f"Copied {partition_date} partition.")
                    num_partitions_copied += 1
                    consecutive_failed_partitions = 0
                except subprocess.CalledProcessError as e:
                    print(f"Error copying {partition_date} partition: {e.stdout.strip()}")
                    failed_partition_dates.append(partition_date)
                    consecutive_failed_partitions += 1
                    if consecutive_failed_partitions >= 5:
                        print(f"Stopping after {consecutive_failed_partitions} errors in a row...")
                        sys.exit(1)
    finally:
        if num_partitions_copied:
            print(f"Copied {num_partitions_copied} of {num_partitions} partitions from {from_table} to {to_table}.")
        if failed_partition_dates:
            print(
                f"Failed to copy {len(failed_partition_dates)} partitions from {from_table} to {to_table}: "
                + ", ".join(str(partition_date) for partition_date in sorted(failed_partition_dates))
            )
    if failed_partition_dates:
        sys.exit(1)

#!/bin/bash
#
# Run 02_drop_affected.sql over every affected partition, writing each cleaned
# partition (prod minus the affected rows) into the backfill staging table. Feed it
# the list of dates that 01_scope_by_date.sql reported as containing affected
# records (one YYYY-MM-DD per line).
#
# Usage:
#   ./run_drop.sh affected_dates.txt
#
# where affected_dates.txt is, e.g., the output of:
#   bq query --use_legacy_sql=false --format=csv "$(cat 01_scope_by_date.sql)" \
#     | tail -n +2 | cut -d, -f1 | sort -u > affected_dates.txt

set -e

DATES_FILE="${1:?usage: run_drop.sh <dates-file>}"
PROJECT="moz-fx-data-backfill-1"
DATASET="telemetry_stable"
TABLE_NAME="third_party_modules_v4"
PARALLELISM="${PARALLELISM:-8}"

SQL="$(cat "$(dirname "$0")/02_drop_affected.sql")"
export SQL PROJECT DATASET TABLE_NAME

cat "${DATES_FILE}" | xargs -P "${PARALLELISM}" -I{} bash -c '
  set -ex
  DATE="{}"
  PART="${DATE//-/}"
  bq query \
    --use_legacy_sql=false \
    --project_id="${PROJECT}" \
    --parameter=submission_date:DATE:"${DATE}" \
    --destination_table="${PROJECT}:${DATASET}.${TABLE_NAME}\$${PART}" \
    --replace=true \
    "${SQL}"
'
echo "Drop complete. Now run 03_validate.sql before copying to prod."

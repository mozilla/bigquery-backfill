#!/bin/bash
#
# Overwrite each prod stable partition with the cleaned version from the backfill
# staging table. This REPLACES prod partitions in place (`bq cp -f`) with the set
# that has the affected records removed. That overwrite is what drops the affected
# rows from prod.
#
# This step requires DSRE assistance.
#
# Usage:
#   ./copy_to_prod.sh affected_dates.txt

set -e

DATES_FILE="${1:?usage: copy_to_prod.sh <dates-file>}"
SRC_PROJECT="moz-fx-data-backfill-2"
DST_PROJECT="moz-fx-data-shared-prod"
DATASET="telemetry_stable"
TABLE_NAME="third_party_modules_v4"
PARALLELISM="${PARALLELISM:-8}"

export SRC_PROJECT DST_PROJECT DATASET TABLE_NAME

cat "${DATES_FILE}" | xargs -P "${PARALLELISM}" -I{} bash -c '
  set -ex
  PART="{}"; PART="${PART//-/}"
  bq cp -f \
    "${SRC_PROJECT}:${DATASET}.${TABLE_NAME}\$${PART}" \
    "${DST_PROJECT}:${DATASET}.${TABLE_NAME}\$${PART}"
'
echo "Prod partitions overwritten. Re-run the detector (counts only) against prod to confirm 0 leaks."

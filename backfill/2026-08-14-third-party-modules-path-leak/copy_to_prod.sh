#!/bin/bash
#
# Overwrite each prod stable partition with the cleaned version from the backfill
# staging table. This REPLACES prod partitions in place (`bq cp -f`) with the set
# that has the affected records removed. That overwrite is what drops the affected
# rows from prod.
#
# Usage:
#   ./copy_to_prod.sh

set -euo pipefail

SRC_PROJECT="moz-fx-data-backfill-2"
DST_PROJECT="moz-fx-data-shared-prod"
DATASET="telemetry_stable"
TABLE_NAME="third_party_modules_v4"
PARALLELISM="${PARALLELISM:-8}"

export SRC_PROJECT DST_PROJECT DATASET TABLE_NAME

# Get partitions present in the staging table.
PARTITIONS="$(
  bq query --use_legacy_sql=false --format=csv --project_id="${SRC_PROJECT}" <<SQL | tail -n +2
SELECT partition_id
FROM \`${SRC_PROJECT}.${DATASET}.INFORMATION_SCHEMA.PARTITIONS\`
WHERE table_name = '${TABLE_NAME}'
  AND partition_id NOT IN ('__NULL__', '__UNPARTITIONED__')
ORDER BY partition_id
SQL
)"

if [[ -z "${PARTITIONS}" ]]; then
  echo "No partitions found in ${SRC_PROJECT}:${DATASET}.${TABLE_NAME}; nothing to copy." >&2
  exit 1
fi

echo "Copying $(echo "${PARTITIONS}" | wc -l | tr -d ' ') staged partitions to prod..."

echo "${PARTITIONS}" | xargs -P "${PARALLELISM}" -n1 bash -c '
  set -ex
  PART="$1"
  bq cp -f \
    "${SRC_PROJECT}:${DATASET}.${TABLE_NAME}\$${PART}" \
    "${DST_PROJECT}:${DATASET}.${TABLE_NAME}\$${PART}"
' _
echo "Prod partitions overwritten. Re-run the detector (counts only) against prod to confirm 0 leaks."

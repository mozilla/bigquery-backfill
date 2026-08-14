#!/bin/bash
#
# Create the staging table `telemetry_stable.third_party_modules_v4` in the
# backfill project with prod's exact schema and partitioning/clustering. Because
# the final step copies whole partitions back into prod with `bq cp -f`, the
# staging schema must match prod exactly.
#
# Run once before kicking off the drop queries.

set -e

PROJECT="moz-fx-data-backfill-2"
SRC_PROJECT="moz-fx-data-shared-prod"
DATASET="telemetry_stable"
TABLE_NAME="third_party_modules_v4"

SRC="${SRC_PROJECT}:${DATASET}.${TABLE_NAME}"
DST="${PROJECT}:${DATASET}.${TABLE_NAME}"
SCHEMA_FILE="/tmp/${TABLE_NAME}_schema.json"

bq mk "${PROJECT}:${DATASET}" 2>/dev/null || true

echo "Mirroring schema: ${SRC} -> ${DST}"
bq show --format=json "${SRC}" | jq '.schema.fields' > "${SCHEMA_FILE}"

# Recreate from scratch so column order matches prod exactly.
bq rm -f -t "${DST}" 2>/dev/null || true
bq mk -t \
  --time_partitioning_field=submission_timestamp \
  --clustering_fields=normalized_channel,sample_id \
  --table "${DST}" \
  "${SCHEMA_FILE}"

echo "Done. Verify clustering/partitioning against prod:"
echo "  bq show ${SRC}"
echo "  bq show ${DST}"

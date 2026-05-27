#!/bin/bash
#
# Pre-create the `firefox_desktop_live.baseline_v1` and
# `firefox_desktop_stable.baseline_v1` tables in the backfill project by copying the
# schema directly from prod. This guarantees the column order in the backfill staging
# tables matches prod, so the final `bq query --append_table=true` can do a name-based
# `SELECT *` insert without column-by-column reordering.
#
# Run once before kicking off the dataflow job.

set -e

PROJECT="moz-fx-data-backfill-1"
SRC_PROJECT="moz-fx-data-shared-prod"
DOCUMENT_TYPE="baseline"
TABLE_NAME="${DOCUMENT_TYPE}_v1"

# Create datasets in the backfill project if they don't exist already. `bq mk` returns
# non-zero if the dataset exists, which is fine — we ignore that.
bq mk "${PROJECT}:firefox_desktop_live"   2>/dev/null || true
bq mk "${PROJECT}:firefox_desktop_stable" 2>/dev/null || true

for SUFFIX in live stable; do
  SRC="${SRC_PROJECT}:firefox_desktop_${SUFFIX}.${TABLE_NAME}"
  DST="${PROJECT}:firefox_desktop_${SUFFIX}.${TABLE_NAME}"
  SCHEMA_FILE="/tmp/${SUFFIX}_${TABLE_NAME}_schema.json"

  echo "Mirroring schema: ${SRC} -> ${DST}"

  bq show --format=json "${SRC}" | jq '.schema.fields' > "${SCHEMA_FILE}"

  # Recreate the destination table from scratch with the mirrored schema. If the table
  # already exists, drop it first — we want the column order to match prod exactly.
  bq rm -f -t "${DST}" 2>/dev/null || true
  bq mk -t \
    --time_partitioning_field=submission_timestamp \
    --clustering_fields=normalized_channel,sample_id \
    --table "${DST}" \
    "${SCHEMA_FILE}"
done

echo "Done. Verify with:"
echo "  bq show --schema ${PROJECT}:firefox_desktop_live.${TABLE_NAME}"
echo "  bq show --schema ${PROJECT}:firefox_desktop_stable.${TABLE_NAME}"

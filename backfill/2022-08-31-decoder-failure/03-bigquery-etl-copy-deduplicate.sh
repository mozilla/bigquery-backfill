#!/bin/bash
set -exo pipefail

# This script assumes it's being run from the bigquery-etl repo, and that 02-gcp-ingestion-beam-decoder.sh
# was run and the associated Dataflow job completed successfully.

PROJECT="moz-fx-data-backfill-10"
# FIXME update this list, see README
TABLES=(
)

DATES=(
    2022-08-31
)

./script/copy_deduplicate \
  --project-id $PROJECT --billing-project $PROJECT \
  -o "${TABLES[@]}" \
  --dates "${DATES[@]}"

#!/bin/bash
set -exo pipefail

# This script assumes it's being run from the bigquery-etl repo, and that 02-gcp-ingestion-beam-decoder.sh
# was run and the associated Dataflow job completed successfully.

PROJECT="moz-fx-data-backfill-10"
TABLES=(
  "firefox_desktop_live.baseline_v1"
  "firefox_desktop_live.deletion_request_v1"
  "firefox_desktop_live.events_v1"
  "firefox_desktop_live.fog_validation_v1"
  "firefox_desktop_live.metrics_v1"
)
DATES=(
    2022-04-12 2022-04-13 2022-04-14 2022-04-15 2022-04-16 2022-04-17 2022-04-18 2022-04-19 2022-04-20 2022-04-21 2022-04-22 2022-04-23 2022-04-24 2022-04-25 2022-04-26 2022-04-27
)

./script/copy_deduplicate \
  --project-id $PROJECT --billing-project $PROJECT \
  -o "${TABLES[@]}" \
  --dates "${DATES[@]}"

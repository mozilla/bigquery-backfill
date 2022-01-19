#!/bin/bash
set -exo pipefail

# This script assumes it's being run from the bigquery-etl repo, and that 01-ingestion-beam-decoder.sh
# was run and the associated Dataflow job completed successfully.

PROJECT="moz-fx-data-backfill-10"
TABLES=(
  "regrets_reporter_ucs_live.main_events_v1"
  "regrets_reporter_ucs_live.video_index_v1"
)
DATES=(
  2021-11-17 2021-11-18 2021-11-19 2021-11-20 2021-11-21 2021-11-22 2021-11-23 2021-11-24 2021-11-25 2021-11-26 2021-11-27 2021-11-28 2021-11-29 2021-11-30
  2021-12-01 2021-12-02 2021-12-03 2021-12-04 2021-12-05 2021-12-06 2021-12-07 2021-12-08 2021-12-09 2021-12-10 2021-12-11 2021-12-12 2021-12-13 2021-12-14 2021-12-15 2021-12-16 2021-12-17 2021-12-18 2021-12-19 2021-12-20 2021-12-21 2021-12-22 2021-12-23 2021-12-24 2021-12-25 2021-12-26 2021-12-27 2021-12-28 2021-12-29 2021-12-30 2021-12-31
  2022-01-01 2022-01-02 2022-01-03 2022-01-04 2022-01-05 2022-01-06 2022-01-07 2022-01-08 2022-01-09
)

./script/copy_deduplicate \
  --project-id $PROJECT --billing-project $PROJECT \
  -o "${TABLES[@]}" \
  --dates "${DATES[@]}"

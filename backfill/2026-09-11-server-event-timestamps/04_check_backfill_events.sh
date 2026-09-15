#!/bin/bash
set -o xtrace -o errexit -o nounset -o pipefail

bq query --project_id=moz-fx-data-backfill-1 --use_legacy_sql=false --max_rows=10 \
  < check_affected_events.sql

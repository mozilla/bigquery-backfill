#!/bin/bash
#
# Append the deduped backfill data into the prod stable table.
#
# This step requires DSRE assistance (see DSRE ticket linked in README.md). Because the
# backfill staging table was created with prod's schema via mirror-prod-tables.sh, a
# name-based `SELECT *` append works directly — no column-by-column INSERT is needed.

set -e

START_DATE="2026-05-19"
END_DATE="2026-05-20"   # confirmed via affected_pings.sql (zero rejections from 2026-05-21 onward)

bq query \
  --use_legacy_sql=false \
  --destination_table='moz-fx-data-shared-prod:firefox_desktop_stable.baseline_v1' \
  --append_table=true \
  "SELECT * FROM \`moz-fx-data-backfill-1.firefox_desktop_stable.baseline_v1\`
   WHERE DATE(submission_timestamp) BETWEEN '${START_DATE}' AND '${END_DATE}'"

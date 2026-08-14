-- Step 2: write only the CLEAN rows of one partition to the staging table
-- (prod minus affected rows, copied byte-for-byte via SELECT *). Run once per
-- affected partition (see 01_scope_by_date.sql), e.g.:
--
--   bq query \
--     --use_legacy_sql=false \
--     --project_id=moz-fx-data-backfill-1 \
--     --parameter=submission_date:DATE:2026-03-15 \
--     --destination_table='moz-fx-data-backfill-1:telemetry_stable.third_party_modules_v4$20260315' \
--     --replace=true \
--     "$(cat 02_drop_affected.sql)"
CREATE TEMP FUNCTION is_leak(x STRING) AS (
  x IS NOT NULL
  AND STRPOS(x, '\\') > 0
  AND NOT STARTS_WITH(LOWER(x), '%programfiles%\\')
  AND NOT STARTS_WITH(LOWER(x), '%programfiles% (x86)\\')
  AND NOT STARTS_WITH(LOWER(x), '%systemroot%\\')
  AND NOT STARTS_WITH(LOWER(x), '%temp%\\')
);

SELECT
  *
FROM
  `moz-fx-data-shared-prod.telemetry_stable.third_party_modules_v4`
WHERE
  DATE(submission_timestamp) = @submission_date
  -- keep only rows that have NO leak in either field
  AND NOT EXISTS (
    SELECT 1 FROM UNNEST(payload.modules) AS m
    WHERE is_leak(m.resolved_dll_name)
  )
  AND NOT EXISTS (
    SELECT 1
    FROM UNNEST(payload.processes) AS p, UNNEST(p.value.events) AS e
    WHERE is_leak(e.requested_dll_name)
  )

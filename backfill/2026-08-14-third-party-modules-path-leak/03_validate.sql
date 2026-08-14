-- Step 3: validate staging before copying to prod. Two checks per partition:
--   1. remaining_leaks in staging MUST be 0.
--   2. staging_rows == prod_rows - prod_affected_rows (dropped exactly the
--      affected rows and nothing else).
-- Counts only — no path value is emitted.
CREATE TEMP FUNCTION is_leak(x STRING) AS (
  x IS NOT NULL
  AND STRPOS(x, '\\') > 0
  AND NOT STARTS_WITH(LOWER(x), '%programfiles%\\')
  AND NOT STARTS_WITH(LOWER(x), '%programfiles% (x86)\\')
  AND NOT STARTS_WITH(LOWER(x), '%systemroot%\\')
  AND NOT STARTS_WITH(LOWER(x), '%temp%\\')
);

WITH staging AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    COUNT(*) AS staging_rows,
    COUNTIF(
      EXISTS (SELECT 1 FROM UNNEST(payload.modules) AS m WHERE is_leak(m.resolved_dll_name))
      OR EXISTS (
        SELECT 1 FROM UNNEST(payload.processes) AS p, UNNEST(p.value.events) AS e
        WHERE is_leak(e.requested_dll_name)
      )
    ) AS remaining_leaks
  FROM `moz-fx-data-backfill-1.telemetry_stable.third_party_modules_v4`
  GROUP BY submission_date
),
prod AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    COUNT(*) AS prod_rows,
    COUNTIF(
      EXISTS (SELECT 1 FROM UNNEST(payload.modules) AS m WHERE is_leak(m.resolved_dll_name))
      OR EXISTS (
        SELECT 1 FROM UNNEST(payload.processes) AS p, UNNEST(p.value.events) AS e
        WHERE is_leak(e.requested_dll_name)
      )
    ) AS prod_affected_rows
  FROM `moz-fx-data-shared-prod.telemetry_stable.third_party_modules_v4`
  WHERE DATE(submission_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)
  GROUP BY submission_date
)
SELECT
  p.submission_date,
  p.prod_rows,
  p.prod_affected_rows,
  s.staging_rows,
  s.remaining_leaks,                                                -- MUST be 0
  s.staging_rows - (p.prod_rows - p.prod_affected_rows) AS row_diff -- MUST be 0
FROM prod p
JOIN staging s USING (submission_date)
WHERE s.remaining_leaks > 0
   OR s.staging_rows != p.prod_rows - p.prod_affected_rows
ORDER BY p.submission_date
-- Zero rows returned = all checks pass.

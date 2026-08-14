-- Step 1: per submission_date, count affected records (rows that will drop).
-- Counts only — never selects a path value (that is the PII we are removing).
-- A row is affected iff any DLL-name value is a leak, in either
--   payload.modules[].resolved_dll_name
--   payload.processes[].value.events[].requested_dll_name   (processes is a map)
-- Use the returned dates as the exact partition list; window capped at 180 days.
--
-- Leak rule (matches WinUtils::PreparePathForTelemetry whitelist): contains a
-- backslash AND does not start with one of the four allowed prefixes (case-insensitive).
CREATE TEMP FUNCTION is_leak(x STRING) AS (
  x IS NOT NULL
  AND STRPOS(x, '\\') > 0
  AND NOT STARTS_WITH(LOWER(x), '%programfiles%\\')
  AND NOT STARTS_WITH(LOWER(x), '%programfiles% (x86)\\')
  AND NOT STARTS_WITH(LOWER(x), '%systemroot%\\')
  AND NOT STARTS_WITH(LOWER(x), '%temp%\\')
);

SELECT
  DATE(submission_timestamp) AS submission_date,
  COUNT(*) AS affected_records,
  COUNT(DISTINCT client_id) AS affected_users
FROM
  `moz-fx-data-shared-prod.telemetry_stable.third_party_modules_v4`
WHERE
  DATE(submission_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)
  AND (
    EXISTS (
      SELECT 1 FROM UNNEST(payload.modules) AS m
      WHERE is_leak(m.resolved_dll_name)
    )
    OR EXISTS (
      SELECT 1
      FROM UNNEST(payload.processes) AS p, UNNEST(p.value.events) AS e
      WHERE is_leak(e.requested_dll_name)
    )
  )
GROUP BY
  submission_date
ORDER BY
  submission_date


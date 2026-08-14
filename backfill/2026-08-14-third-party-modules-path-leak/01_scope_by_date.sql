-- Step 1: which partitions contain affected records, and how many rows drop?
--
-- This is the detector logic from bug 2061342, reduced to COUNTS ONLY and rolled
-- up to the ROW (ping) level, because we are dropping whole affected records — not
-- rewriting fields. It deliberately does NOT select any path value (that is the
-- PII we are removing — never write it to a shared location, a query result that
-- gets cached, a paste, or this repo).
--
-- A record (row) is AFFECTED iff any of its DLL-name values is a leak, in either
--   payload.modules[].resolved_dll_name
--   payload.processes[].value.events[].requested_dll_name   (processes is a map)
--
-- Output: one row per submission_date with a non-zero count of affected records.
-- affected_records = exactly how many rows will be dropped from that partition.
-- Use the returned dates to build the exact list of partitions to process (clean
-- partitions are left alone).
--
-- The backfill window is capped at the last 180 days (see README). The
-- submission_timestamp filter both prunes partitions (cost) and enforces that cap.
--
-- Leak rule (matches WinUtils::PreparePathForTelemetry whitelist): a value is a
-- leak iff it contains a backslash AND does not start with one of the four allowed
-- folder prefixes (case-insensitive, matching nsCaseInsensitiveStringComparator).
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

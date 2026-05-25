-- Per-day count of affected baseline pings, used to confirm the date range of the
-- backfill and to spot-check expected reingestion volume.
--
-- Queries the aggregated error-count table (mozdata.monitoring.structured_detailed_error_counts)
-- rather than payload_bytes_error.structured, which is access-restricted because it
-- contains raw payload bytes (PII). The aggregated table has all the dimensions we need
-- for scoping.
--
-- The incident started on 2026-05-19 (Firefox 151 release day). The schema validation
-- was loosened by mozilla-pipeline-schemas#871 and the offending rollout was corrected,
-- so the rejection rate should decay to zero soon after. Use this query to find the
-- actual last day with non-trivial rejected baseline pings; that is the END_DATE used
-- in start_dataflow.sh, dedupe.sql, and insert_to_prod.sh.

SELECT
  DATE(hour) AS submission_date,
  SUM(error_count) AS rejected_baseline_pings
FROM
  `mozdata.monitoring.structured_detailed_error_counts`
WHERE
  DATE(hour) >= '2026-05-19'
  AND document_namespace = 'firefox-desktop'
  AND document_type      = 'baseline'
  AND error_type         = 'ParsePayload'
  AND error_message LIKE '%cert_validation_success_by_ca_2%'
GROUP BY
  submission_date
ORDER BY
  submission_date

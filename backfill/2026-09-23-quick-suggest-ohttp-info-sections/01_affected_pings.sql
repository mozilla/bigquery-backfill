-- Per-hour count of rejected suggest pings during the cutover window, used to pin the
-- date range for the reingest and to spot-check expected recovery volume.
--
-- Queries the aggregated error-count table rather than payload_bytes_error.structured,
-- which is access restricted because it contains raw payload bytes.
--
-- Two error shapes are expected, in opposite directions:
--   * old shape pings failing additionalProperties against the new glean-min schema
--   * min shape pings from already updated clients failing
--     required: [ping_info, client_info] against the old schema
-- Both are recoverable; the error rows hold the original unscrubbed payload.
--
-- The cutover window was 2026-09-22 to 2026-09-23. Confirm counts fall away outside it
-- before locking the range in start_dataflow.sh.

SELECT
  DATE(hour) AS submission_date,
  document_namespace,
  document_type,
  error_type,
  SUM(error_count) AS rejected_pings
FROM
  `mozdata.monitoring.structured_detailed_error_counts`
WHERE
  DATE(hour) BETWEEN '2026-09-22' AND '2026-09-23'
  AND (
        (document_namespace = 'firefox-desktop'
         AND document_type IN ('quick-suggest', 'urlbar-keyword-exposure'))
     OR (document_namespace IN ('org-mozilla-firefox', 'org-mozilla-firefox-beta',
                                'org-mozilla-fenix', 'org-mozilla-fenix-nightly',
                                'org-mozilla-fennec-aurora')
         AND document_type IN ('fx-suggest', 'fx-suggest-api'))
     OR (document_namespace IN ('org-mozilla-ios-firefox', 'org-mozilla-ios-firefoxbeta',
                                'org-mozilla-ios-fennec')
         AND document_type = 'fx-suggest')
      )
GROUP BY
  submission_date,
  document_namespace,
  document_type,
  error_type
ORDER BY
  submission_date,
  document_namespace,
  document_type

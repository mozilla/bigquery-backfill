-- Copy the rejected pings into the sandbox.
--
-- Stands in for the cloudops-infra module's init_query, which is unavailable while
-- backfill project access is pending. Contains RAW PAYLOAD BYTES; confirm the sandbox is
-- cleared to hold them before running.
--
-- Excludes payloads that are not JSON objects. Those fail in ParsePayload before schema
-- validation ever runs, so they were already broken when they landed in
-- payload_bytes_error and this backfill cannot recover them. Leaving them in swept
-- ~385k iOS rows into the first run and made the validation accounting show a 22%
-- shortfall by construction.
--
-- No broader error_type filter than that: anything failing for another unrelated reason
-- simply re-errors into the decoder's error output rather than being silently dropped.

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.backfill_input.payload_bytes_error`
PARTITION BY DATE(submission_timestamp)
AS
SELECT *
FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE DATE(submission_timestamp) BETWEEN '2026-09-22' AND '2026-09-23'
  AND (
        (document_namespace = 'firefox-desktop' AND document_type IN ('quick-suggest', 'urlbar-keyword-exposure'))
     OR (document_namespace IN ('org-mozilla-firefox', 'org-mozilla-firefox-beta',
                        'org-mozilla-fenix', 'org-mozilla-fenix-nightly',
                        'org-mozilla-fennec-aurora')
   AND document_type IN ('fx-suggest', 'fx-suggest-api'))
     OR (document_namespace IN ('org-mozilla-ios-firefox', 'org-mozilla-ios-firefoxbeta',
                        'org-mozilla-ios-fennec')
   AND document_type = 'fx-suggest')
      )
  AND error_message NOT LIKE '%json value is not an object%';

-- Validate the Decoder output before deduping. Run each statement in turn.
-- Everything here reads staging only; nothing touches prod.


-- STATEMENT 1: what the reingest produced, per table per day.
-- Compare against 01_affected_pings.sql. Output + residual errors should account for the
-- full input. A table with zero rows is not necessarily wrong, some doctypes may have had
-- no rejections, but check that against statement 1 of 01 rather than assuming.

SELECT 'firefox_desktop__quick_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'firefox_desktop__urlbar_keyword_exposure' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox__fx_suggest_api' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox_beta__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox_beta__fx_suggest_api' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix__fx_suggest_api' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix_nightly__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix_nightly__fx_suggest_api' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fennec_aurora__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fennec_aurora__fx_suggest_api' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_ios_firefox__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_ios_firefoxbeta__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_ios_fennec__fx_suggest' AS staging_table, DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_out, COUNT(DISTINCT document_id) AS distinct_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1`
GROUP BY dt
ORDER BY staging_table, dt;


-- STATEMENT 2: residual errors. Anything here failed for a reason unrelated to the
-- info sections change, or means the scrubber did not do what we expect. Expect very few.
-- If these are still schema validation failures mentioning client_info or ping_info, the
-- decoder build does not have PR #2980.

SELECT
  document_namespace,
  document_type,
  error_type,
  SUBSTR(error_message, 1, 300) AS error_message,
  COUNT(*) AS n
FROM `BACKFILL_PROJECT.backfill_input.decoder_errors`
GROUP BY document_namespace, document_type, error_type, error_message
ORDER BY n DESC;


-- STATEMENT 3: accounting. rows_in should equal rows_out + rows_errored.
-- A shortfall means rows were dropped silently, which is worth understanding before
-- continuing.

WITH rows_in AS (
  SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.backfill_input.payload_bytes_error`
),
rows_out AS (
  SELECT SUM(n) AS n FROM (
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
UNION ALL
    SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1`
  )
),
rows_err AS (
  SELECT COUNT(*) AS n FROM `BACKFILL_PROJECT.backfill_input.decoder_errors`
)
SELECT
  (SELECT n FROM rows_in) AS rows_in,
  (SELECT n FROM rows_out) AS rows_out,
  (SELECT n FROM rows_err) AS rows_errored,
  (SELECT n FROM rows_in) - IFNULL((SELECT n FROM rows_out), 0)
    - (SELECT n FROM rows_err) AS unaccounted;


-- STATEMENT 4: content sanity.
--   * dates must fall inside the cutover window
--   * additional_properties should be empty. If the info sections had somehow survived
--     into a valid ping they would land there, so anything non-null is worth reading.
--   * submission_timestamp must be preserved from the original ping, not set to the
--     reingest time, or rows land in the wrong partition.

SELECT 'firefox_desktop__quick_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1`
UNION ALL
SELECT 'firefox_desktop__urlbar_keyword_exposure' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1`
UNION ALL
SELECT 'org_mozilla_firefox__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_firefox__fx_suggest_api' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1`
UNION ALL
SELECT 'org_mozilla_firefox_beta__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_firefox_beta__fx_suggest_api' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1`
UNION ALL
SELECT 'org_mozilla_fenix__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_fenix__fx_suggest_api' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1`
UNION ALL
SELECT 'org_mozilla_fenix_nightly__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_fenix_nightly__fx_suggest_api' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1`
UNION ALL
SELECT 'org_mozilla_fennec_aurora__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_fennec_aurora__fx_suggest_api' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1`
UNION ALL
SELECT 'org_mozilla_ios_firefox__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_ios_firefoxbeta__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
UNION ALL
SELECT 'org_mozilla_ios_fennec__fx_suggest' AS staging_table,
       MIN(DATE(submission_timestamp)) AS min_dt,
       MAX(DATE(submission_timestamp)) AS max_dt,
       COUNTIF(additional_properties IS NOT NULL) AS has_additional_props,
       COUNT(*) - COUNT(DISTINCT document_id) AS dupe_docs
FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1`
ORDER BY staging_table;

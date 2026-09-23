-- Load recovered pings into prod. Routing is by date:
--
--   2026-09-22  ->  prod STABLE. copy_deduplicate's lookback has already passed this
--                   date, so it would never be promoted from live.
--   2026-09-23  ->  prod LIVE. Tonight's copy_deduplicate run promotes it into stable and
--                   dedupes by document_id on the way.
--
-- MERGE rather than INSERT, so the load is re-runnable without duplicating.
--
-- PARTITION FILTER: both prod tables have require_partition_filter set, and
--   AND DATE(t.submission_timestamp) = '2026-09-22'
-- does NOT satisfy it inside an ON clause. It fails with
--   Cannot query over table ... without a filter over column(s) 'submission_timestamp'
-- A half open range on the raw timestamp column does satisfy it, so that is the form used
-- here. Note this only surfaces when the USING source is non-empty; with an empty source
-- BigQuery skips the target scan and the statement succeeds regardless.
--
-- INSERT ROW works without a column list because staging_stable is built with prod
-- stable's column order, and live and stable share one generated schema.
--
-- Section 2 must complete before tonight's copy_deduplicate run.
-- Section 1 writes directly to prod stable and may need DSRE.


-- ===========================================================================
-- SECTION 1: 2026-09-22 -> prod STABLE
-- ===========================================================================

MERGE INTO `moz-fx-data-shared-prod.firefox_desktop_stable.quick_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.firefox_desktop__quick_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.firefox_desktop_stable.urlbar_keyword_exposure_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.firefox_desktop__urlbar_keyword_exposure_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_ios_firefox_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefox__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_ios_fennec_stable.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_fennec__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-23')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-22')
AND t.submission_timestamp <  TIMESTAMP('2026-09-23')
WHEN NOT MATCHED THEN INSERT ROW;


-- ===========================================================================
-- SECTION 2: 2026-09-23 -> prod LIVE
--
-- 2026-09-23 is the partition the sink is actively writing to. An insert-only MERGE does
-- not modify buffered rows, but test one table before running all 15. Rows inserted by a
-- previous run may still be in the streaming buffer and invisible to the ON clause, so a
-- quick re-run can still duplicate; harmless, copy_deduplicate dedupes on promotion.
-- ===========================================================================

MERGE INTO `moz-fx-data-shared-prod.firefox_desktop_live.quick_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.firefox_desktop__quick_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.firefox_desktop_live.urlbar_keyword_exposure_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.firefox_desktop__urlbar_keyword_exposure_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_live.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_beta_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_firefox_beta_live.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_live.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.fx_suggest_api_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_ios_firefox_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefox__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;

MERGE INTO `moz-fx-data-shared-prod.org_mozilla_ios_fennec_live.fx_suggest_v1` AS t
USING (
  SELECT * FROM `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_fennec__fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-23')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
) AS s
ON  t.document_id = s.document_id
AND t.submission_timestamp >= TIMESTAMP('2026-09-23')
AND t.submission_timestamp <  TIMESTAMP('2026-09-24')
WHEN NOT MATCHED THEN INSERT ROW;


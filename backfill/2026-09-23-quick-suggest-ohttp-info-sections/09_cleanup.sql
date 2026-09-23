-- Cleanup. Run only after verification passes.
--
-- The sandbox held raw payload bytes for the duration of this backfill. Removing them is
-- part of the work, not an afterthought, and it is the reason the sandbox route needed
-- sign-off in the first place.
--
-- Order matters: raw payloads first, then staging, then backups last, since the backups
-- are the rollback path if verification turns up a problem.

-- 1. Raw payloads. Highest priority, drop as soon as the reingest is verified.
DROP TABLE IF EXISTS `BACKFILL_PROJECT.backfill_input.payload_bytes_error`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.backfill_input.decoder_errors`;

-- 2. Staging tables.
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1`;

DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.firefox_desktop__quick_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.firefox_desktop__urlbar_keyword_exposure_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_api_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefox__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefoxbeta__fx_suggest_v1`;
DROP TABLE IF EXISTS `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_fennec__fx_suggest_v1`;

-- 3. Datasets, once empty.
--   bq rm -d BACKFILL_PROJECT:backfill_input
--   bq rm -d BACKFILL_PROJECT:staging_live
--   bq rm -d BACKFILL_PROJECT:staging_stable

-- 4. Dataflow temp files in GCS. Not covered by the DDL above.
--   gsutil -m rm -r gs://BACKFILL_STAGING_BUCKET/temp/

-- 5. Backups, LAST, and only once the prod state is confirmed good. These are the
--    rollback path, and they still carry the pre scrub geo and isp values.
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.firefox_desktop_stable__quick_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.firefox_desktop_stable__urlbar_keyword_exposure_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_firefox_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_firefox_stable__fx_suggest_api_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_firefox_beta_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_firefox_beta_stable__fx_suggest_api_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_fenix_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_fenix_stable__fx_suggest_api_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_fenix_nightly_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_fenix_nightly_stable__fx_suggest_api_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_fennec_aurora_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_fennec_aurora_stable__fx_suggest_api_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_ios_firefox_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_ios_firefoxbeta_stable__fx_suggest_v1_20260922`;
-- DROP TABLE IF EXISTS `BACKFILL_PROJECT.backup.org_mozilla_ios_fennec_stable__fx_suggest_v1_20260922`;

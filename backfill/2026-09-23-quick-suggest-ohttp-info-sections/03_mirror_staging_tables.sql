-- Pre-create staging tables mirroring prod schema and column order, so the final append
-- can be name based.
--
-- staging_live mirrors prod LIVE and staging_stable mirrors prod STABLE. They are not
-- interchangeable: live clusters on submission_timestamp, stable clusters on
-- (normalized_channel, sample_id). Mirroring both from stable makes the Decoder's
-- BigQuery load fail with
--   Incompatible table partitioning specification
-- because start_dataflow.sh passes --bqClusteringFields=submission_timestamp.
--
-- The ALTERs drop two properties CREATE TABLE LIKE carries over from prod that are
-- unhelpful on staging:
--   require_partition_filter, which would force a partition filter on every validation
--     and dedupe query
--   partition expiration, which would quietly age staging out mid backfill
--
-- If the staging tables already exist with the wrong clustering, drop them first:
--   bq rm -f -t BACKFILL_PROJECT:staging_live.<table>

-- Create the datasets first:
--   bq mk -d --location=US BACKFILL_PROJECT:backfill_input
--   bq mk -d --location=US BACKFILL_PROJECT:staging_live
--   bq mk -d --location=US BACKFILL_PROJECT:staging_stable
--
-- staging_stable tables are created by 05_dedupe.sql with CREATE OR REPLACE, which would
-- override anything defined here, so they are not pre-created.

-- The Decoder's error output table must exist before the job runs. gcp-ingestion routes
-- to the error collection rather than auto-creating a destination, and BigQueryIO will
-- not create it for an empty write either, so without this the job fails with
--   Not found: Table BACKFILL_PROJECT:backfill_input.decoder_errors
CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.backfill_input.decoder_errors`
LIKE `moz-fx-data-shared-prod.payload_bytes_error.structured`;
ALTER TABLE `BACKFILL_PROJECT.backfill_input.decoder_errors`
SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1` LIKE `moz-fx-data-shared-prod.firefox_desktop_live.quick_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1` LIKE `moz-fx-data-shared-prod.firefox_desktop_live.urlbar_keyword_exposure_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_firefox_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_firefox_live.fx_suggest_api_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_firefox_beta_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_firefox_beta_live.fx_suggest_api_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fenix_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fenix_live.fx_suggest_api_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.fx_suggest_api_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.fx_suggest_api_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_ios_firefox_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);

CREATE TABLE IF NOT EXISTS `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_ios_fennec_live.fx_suggest_v1`;
ALTER TABLE `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1` SET OPTIONS (require_partition_filter = FALSE, partition_expiration_days = NULL);


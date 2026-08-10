-- Per-table queries for the glean v2 table swap, run against the full test set.
-- The README shows examples for metrics_v1 only. This file has the same queries
-- for every test table. Run the section that matches the README step you're on.
--
-- Test tables:
--   org_mozilla_fenix_nightly_stable: metrics_v1, sync_v1, first_session_v1,
--     adjust_attribution_v1, health_v1, captcha_detection_v1
--   org_mozilla_fennec_aurora_stable: metrics_v1, sync_v1, captcha_detection_v1,
--     first_session_v1, health_v1, adjust_attribution_v1


-- ============================================================================
-- Setup step 5: Copy stage v1 stable tables to backfill project
-- ============================================================================

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.metrics_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.sync_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.first_session_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.adjust_attribution_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.adjust_attribution_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.health_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.captcha_detection_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.metrics_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.sync_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.captcha_detection_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.first_session_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.health_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.adjust_attribution_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.adjust_attribution_v1`;


-- ============================================================================
-- Stage step 5: Copy v1 live tables to backfill project
-- ============================================================================

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.metrics_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.sync_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.first_session_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.adjust_attribution_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.adjust_attribution_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.health_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.captcha_detection_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.metrics_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.sync_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.captcha_detection_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.first_session_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.health_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.adjust_attribution_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.adjust_attribution_v1`;


-- ============================================================================
-- Stage step 6: Drop v1 live tables and rename v2 tables (needs Cloud Eng)
-- ============================================================================

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.metrics_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.sync_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.first_session_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.adjust_attribution_v2` RENAME TO adjust_attribution_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.health_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.sync_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.first_session_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.health_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.adjust_attribution_v2` RENAME TO adjust_attribution_v1;


-- ============================================================================
-- Stage step 8: Drop v1 stable tables and rename v2 tables (needs Cloud Eng)
-- ============================================================================

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.metrics_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.sync_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.first_session_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.adjust_attribution_v2` RENAME TO adjust_attribution_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.health_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.sync_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.first_session_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.health_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.adjust_attribution_v2` RENAME TO adjust_attribution_v1;


-- ============================================================================
-- Prod, live backup: Copy v1 live tables to backfill project
-- ============================================================================

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.metrics_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.sync_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.first_session_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.adjust_attribution_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.adjust_attribution_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.health_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.captcha_detection_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.metrics_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.sync_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.captcha_detection_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.first_session_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.health_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.adjust_attribution_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.adjust_attribution_v1`;


-- ============================================================================
-- Prod, live drop/rename: Drop v1 live tables and rename v2 tables (needs Cloud Eng)
-- ============================================================================

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.metrics_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.sync_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.first_session_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.adjust_attribution_v2` RENAME TO adjust_attribution_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.health_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.sync_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.first_session_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.health_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.adjust_attribution_v2` RENAME TO adjust_attribution_v1;


-- ============================================================================
-- Prod, stable backup: Copy prod v1 stable tables to backfill project
-- ============================================================================

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.metrics_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.sync_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.first_session_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.adjust_attribution_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.adjust_attribution_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.health_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.captcha_detection_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.metrics_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.sync_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.sync_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.captcha_detection_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.captcha_detection_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.first_session_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.first_session_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.health_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.health_v1`;

CREATE SNAPSHOT TABLE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.adjust_attribution_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.adjust_attribution_v1`;


-- ============================================================================
-- Prod, stable drop/rename: Drop v1 stable tables and rename v2 tables (needs Cloud Eng)
-- ============================================================================

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.metrics_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.sync_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.first_session_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.adjust_attribution_v2` RENAME TO adjust_attribution_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.health_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v2` RENAME TO metrics_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.sync_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.sync_v2` RENAME TO sync_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.captcha_detection_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.captcha_detection_v2` RENAME TO captcha_detection_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.first_session_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.first_session_v2` RENAME TO first_session_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.health_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.health_v2` RENAME TO health_v1;

DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.adjust_attribution_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.adjust_attribution_v2` RENAME TO adjust_attribution_v1;


-- ============================================================================
-- Backout, stage: undo the rename and restore v1 from the backfill snapshots
-- For each table: rename the current v1 (the former v2) back to v2, then restore
-- the v1 backup taken before the swap. Live backups are in *_live_stage, stable
-- backups in *_stable_stage. Only run this for tables that were actually swapped.
-- ============================================================================

-- Live tables
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.metrics_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.sync_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.first_session_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.adjust_attribution_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.health_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.metrics_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.sync_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.first_session_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.health_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.adjust_attribution_v1`;

-- Stable tables
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.metrics_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.sync_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.first_session_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.adjust_attribution_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.health_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.metrics_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.sync_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.first_session_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.health_v1`;

ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.adjust_attribution_v1`;


-- ============================================================================
-- Backout, prod: undo the rename and restore v1 from the backfill snapshots
-- Same as backout stage but against moz-fx-data-shared-prod and the *_prod backups.
-- Only run this for tables that were actually swapped.
-- ============================================================================

-- Live tables
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.metrics_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.sync_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.first_session_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.adjust_attribution_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.health_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.metrics_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.sync_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.first_session_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.health_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.adjust_attribution_v1`;

-- Stable tables
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.metrics_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.sync_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.first_session_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.adjust_attribution_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.health_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.metrics_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.sync_v1` RENAME TO sync_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.sync_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.sync_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.captcha_detection_v1` RENAME TO captcha_detection_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.captcha_detection_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.captcha_detection_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.first_session_v1` RENAME TO first_session_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.first_session_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.first_session_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.health_v1` RENAME TO health_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.health_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.health_v1`;

ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.adjust_attribution_v1` RENAME TO adjust_attribution_v2;
CREATE TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.adjust_attribution_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.adjust_attribution_v1`;


-- ============================================================================
-- Drop play_store_attribution: these tables are empty for both test apps and
-- never got a v2, so they skip the backup/rename steps entirely. Drop v1 during
-- the deploy pause and let the next bigquery deploy recreate it with the
-- glean.2 schema. Verify the tables are empty in all four dataset variants
-- before running this.
-- ============================================================================

-- Emptiness check to run first. Reads partition metadata instead of the tables
-- so it needs no partition filter and scans no data. Expect zero rows back;
-- anything returned means that table has data and needs the normal
-- backup/swap treatment instead of a drop.
WITH partitions AS (
  SELECT 'stage' AS env, 'org_mozilla_fenix_nightly_live' AS dataset, table_name, partition_id, total_rows
  FROM `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'stage', 'org_mozilla_fennec_aurora_live', table_name, partition_id, total_rows
  FROM `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'stage', 'org_mozilla_fenix_nightly_stable', table_name, partition_id, total_rows
  FROM `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'stage', 'org_mozilla_fennec_aurora_stable', table_name, partition_id, total_rows
  FROM `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'prod', 'org_mozilla_fenix_nightly_live', table_name, partition_id, total_rows
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'prod', 'org_mozilla_fennec_aurora_live', table_name, partition_id, total_rows
  FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'prod', 'org_mozilla_fenix_nightly_stable', table_name, partition_id, total_rows
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.INFORMATION_SCHEMA.PARTITIONS`
  UNION ALL
  SELECT 'prod', 'org_mozilla_fennec_aurora_stable', table_name, partition_id, total_rows
  FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.INFORMATION_SCHEMA.PARTITIONS`
)
SELECT env, dataset, SUM(total_rows) AS row_count
FROM partitions
WHERE table_name = 'play_store_attribution_v1'
GROUP BY env, dataset
HAVING SUM(total_rows) > 0
ORDER BY env, dataset;

-- Stage
DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_live.play_store_attribution_v1`;
DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.play_store_attribution_v1`;
DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fenix_nightly_stable.play_store_attribution_v1`;
DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.play_store_attribution_v1`;

-- Prod
DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.play_store_attribution_v1`;
DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.play_store_attribution_v1`;
DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.play_store_attribution_v1`;
DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.play_store_attribution_v1`;

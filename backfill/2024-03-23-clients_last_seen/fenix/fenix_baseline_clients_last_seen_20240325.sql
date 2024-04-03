CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.backfills_staging_derived.fenix_baseline_clients_last_seen_20240325`
AS
SELECT
  "org_mozilla_firefox" AS normalized_app_id,
  * REPLACE (
    mozfun.norm.fenix_app_info("org_mozilla_firefox", app_build).channel AS normalized_channel
  ),
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_firefox_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_firefox_beta" AS normalized_app_id,
  * REPLACE (
    mozfun.norm.fenix_app_info("org_mozilla_firefox_beta", app_build).channel AS normalized_channel
  ),
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_firefox_beta_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_fenix" AS normalized_app_id,
  * REPLACE (
    mozfun.norm.fenix_app_info("org_mozilla_fenix", app_build).channel AS normalized_channel
  ),
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_fenix_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_fenix_nightly" AS normalized_app_id,
  * REPLACE (
    mozfun.norm.fenix_app_info("org_mozilla_fenix_nightly", app_build).channel AS normalized_channel
  ),
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_fenix_nightly_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_fennec_aurora" AS normalized_app_id,
  * REPLACE (
    mozfun.norm.fenix_app_info("org_mozilla_fennec_aurora", app_build).channel AS normalized_channel
  ),
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_fennec_aurora_baseline_clients_last_seen_20240325`
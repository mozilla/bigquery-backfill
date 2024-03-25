CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.backfills_staging_derived.focus_android_baseline_clients_last_seen_20240325`
AS
SELECT
  "org_mozilla_focus" AS normalized_app_id,
  * REPLACE ("release" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_focus_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_focus_beta" AS normalized_app_id,
  * REPLACE ("beta" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_focus_beta_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_focus_nightly" AS normalized_app_id,
  * REPLACE ("nightly" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_focus_nightly_baseline_clients_last_seen_20240325`
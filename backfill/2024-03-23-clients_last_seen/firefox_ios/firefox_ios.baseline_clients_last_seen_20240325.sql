CREATE OR REPLACE VIEW
    `moz-fx-data-shared-prod.backfills_staging_derived.firefox_ios_baseline_clients_last_seen_20240325`
AS
SELECT
  "org_mozilla_ios_firefox" AS normalized_app_id,
  * REPLACE ("release" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_ios_firefox_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_ios_firefoxbeta" AS normalized_app_id,
  * REPLACE ("beta" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_ios_firefoxbeta_baseline_clients_last_seen_20240325`
UNION ALL
SELECT
  "org_mozilla_ios_fennec" AS normalized_app_id,
  * REPLACE ("nightly" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_ios_fennec_baseline_clients_last_seen_20240325`;
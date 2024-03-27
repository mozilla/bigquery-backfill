CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.backfills_staging_derived.klar_ios_baseline_clients_last_seen_20240325`
AS
SELECT
  "org_mozilla_ios_klar" AS normalized_app_id,
  * REPLACE ("release" AS normalized_channel)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_ios_klar_baseline_clients_last_seen_20240325`
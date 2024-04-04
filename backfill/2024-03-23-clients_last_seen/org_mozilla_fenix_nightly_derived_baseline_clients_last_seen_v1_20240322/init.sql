-- Generated via bigquery_etl.glean_usage
CREATE TABLE IF NOT EXISTS
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_fenix_nightly_derived_baseline_clients_last_seen_v1_20240322`
PARTITION BY
  submission_date
CLUSTER BY
  normalized_channel,
  sample_id
OPTIONS
  (require_partition_filter = TRUE)
AS
SELECT *
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_derived.baseline_clients_last_seen_v1`
WHERE submission_date <= '2021-02-27'
UNION ALL
SELECT
  * EXCEPT(days_active_bits), days_active_bits
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_fenix_nightly_derived_baseline_clients_last_seen_v1_20240322_active_bits`
WHERE submission_date > '2021-02-27'

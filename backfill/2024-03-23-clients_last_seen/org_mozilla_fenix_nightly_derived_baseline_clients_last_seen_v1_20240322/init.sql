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
SELECT
  days_seen_bits AS days_seen_bits,
  days_active_bits AS days_active_bits,
  days_created_profile_bits AS days_created_profile_bits,
  -- We make sure to delay * until the end so that as new columns are added
  -- to the daily table we can add those columns in the same order to the end
  -- of this schema, which may be necessary for the daily join query between
  -- the two tables to validate.
  * EXCEPT(days_seen_bits, days_active_bits, days_created_profile_bits)
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_derived.baseline_clients_last_seen_v1`
WHERE submission_date <= '2021-02-27'
UNION ALL
SELECT
  days_seen_bits AS days_seen_bits,
  days_active_bits AS days_active_bits,
  days_created_profile_bits AS days_created_profile_bits,
  -- We make sure to delay * until the end so that as new columns are added
  -- to the daily table we can add those columns in the same order to the end
  -- of this schema, which may be necessary for the daily join query between
  -- the two tables to validate.
  * EXCEPT(days_seen_bits, days_active_bits, days_created_profile_bits)
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_fenix_nightly_derived_baseline_clients_last_seen_v1_20240322_active_bits`
WHERE submission_date > '2021-02-27'

CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_focus_nightly_baseline_clients_last_seen_20240325`
AS
SELECT
  `moz-fx-data-shared-prod`.udf.pos_of_trailing_set_bit(days_seen_bits) AS days_since_seen,
  `moz-fx-data-shared-prod`.udf.pos_of_trailing_set_bit(days_active_bits) AS days_since_active,
  `moz-fx-data-shared-prod`.udf.pos_of_trailing_set_bit(
    days_created_profile_bits
  ) AS days_since_created_profile,
  `moz-fx-data-shared-prod`.udf.pos_of_trailing_set_bit(
    days_seen_session_start_bits
  ) AS days_since_seen_session_start,
  `moz-fx-data-shared-prod`.udf.pos_of_trailing_set_bit(
    days_seen_session_end_bits
  ) AS days_since_seen_session_end,
  *
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_focus_nightly_derived_baseline_clients_last_seen_v1_20240322`

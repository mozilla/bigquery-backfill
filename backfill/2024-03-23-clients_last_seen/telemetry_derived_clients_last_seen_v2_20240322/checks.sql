-- Generated via bigquery_etl.glean_usage

#warn
{{ is_unique(["client_id"], where="submission_date = @submission_date") }}

#warn
{{ min_row_count(1, where="submission_date = @submission_date") }}

#warn
{{ not_null([
  "submission_date",
  "client_id",
  "sample_id",
  "first_seen_date",
  "days_seen_bits",
  "days_active_bits",
  "days_created_profile_bits",
  "days_seen_session_start_bits",
  "days_seen_session_end_bits"
  ], where="submission_date = @submission_date") }}

#warn
SELECT
  IF(
    COUNTIF(normalized_channel NOT IN ("nightly", "aurora", "release", "Other", "beta", "esr")) > 0,
    ERROR("Unexpected values for field normalized_channel detected."),
    NULL
  )
FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20240322`
WHERE
  submission_date = @submission_date;

#warn
{{ matches_pattern(column="country", pattern="^[A-Z]{2}$", where="submission_date = @submission_date") }}

#warn
{{ value_length(column="client_id", expected_length=36, where="submission_date = @submission_date") }}


#fail
WITH production_version AS
(
 SELECT
     submission_date,
     COUNT(DISTINCT client_id) AS client_count
 FROM
    `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6`
 WHERE
    submission_date = @submission_date
 GROUP BY submission_date
)
, backfilled_version AS
(
 SELECT
  submission_date,
  COUNT(DISTINCT client_id) AS client_count
 FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20240322`
 WHERE
  submission_date = @submission_date
  AND mozfun.bits28.days_since_seen(days_seen_bits) = 0
  GROUP BY submission_date
)
,check_results AS
(
 SELECT
   COUNTIF(backfilled_version.client_count IS DISTINCT FROM production_version.client_count) AS client_count_diff
 FROM production_version LEFT JOIN backfilled_version
 USING(submission_date)
)
SELECT
 IF(
 ABS((SELECT client_count_diff FROM check_results)) > 0,
 ERROR(
   CONCAT("Results don't match. Production has ",
   STRING(((SELECT submission_date FROM production_version))),
   ": ",
   ABS((SELECT client_count FROM production_version)),
   ". Backfill has ",
   IFNULL(((SELECT client_count FROM backfilled_version)), 0)
   )
 ),
 NULL
 );

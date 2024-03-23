#fail
WITH production_version AS
(
 SELECT
     submission_date,
     COUNT(DISTINCT client_id) AS client_count,
     COUNT(DISTINCT is_new_profile) AS new_profile_count
 FROM
    `moz-fx-data-shared-prod.org_mozilla_ios_firefox_derived.baseline_clients_daily_v1`
 WHERE
    submission_date = @submission_date
 GROUP BY submission_date
)
, backfilled_version AS
(
 SELECT
  submission_date,
  COUNT(DISTINCT client_id) AS client_count,
  COUNT(DISTINCT is_new_profile) AS new_profile_count
 FROM
  `moz-fx-data-shared-prod.backfills_staging_derived.org_mozilla_ios_firefox_derived_baseline_clients_last_seen_v1_20240322`
 WHERE
  submission_date = @submission_date
  AND mozfun.bits28.days_since_seen(days_seen_bits) = 0
  GROUP BY submission_date
)
,check_results AS
(
 SELECT
   COUNTIF(backfilled_version.client_count IS DISTINCT FROM production_version.client_count) AS client_count_diff,
   COUNTIF(backfilled_version.new_profile_count IS DISTINCT FROM production_version.new_profile_count) AS new_profile_count_diff
 FROM production_version LEFT JOIN backfilled_version
 USING(submission_date)
)
SELECT
 IF(
 ABS((SELECT client_count_diff FROM check_results)) > 0 OR ABS((SELECT new_profile_count_diff FROM check_results)) > 0,
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

-- Null out IP derived geo and isp on the suggest pings that moved to OHTTP.
-- Run one statement at a time, one date slice at a time.
-- Substitute the timestamp literals; do not run the whole file as a script.
-- Half open timestamp range, not DATE(...) BETWEEN: these tables have
-- require_partition_filter set and the DATE form is not reliably accepted for
-- partition elimination in DML.
-- Runs after the reingest prod insert; covers historical and recovered rows together.
-- SCOPE IS ALL HISTORICAL DATA, not the cutover window. The date literals exist only to
-- slice the work for cost and resumability; the slices must cover every table in full,
-- from its earliest partition (statement 1 of 02_scope.sql) through CURRENT_DATE.

UPDATE `moz-fx-data-shared-prod.firefox_desktop_stable.quick_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.firefox_desktop_stable.urlbar_keyword_exposure_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_api_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_api_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_api_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_api_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_api_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_ios_firefox_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);

UPDATE `moz-fx-data-shared-prod.org_mozilla_ios_fennec_stable.fx_suggest_v1`
SET
    metadata.geo.city = NULL,
    metadata.geo.country = NULL,
    metadata.geo.db_version = NULL,
    metadata.geo.subdivision1 = NULL,
    metadata.geo.subdivision2 = NULL,
    metadata.isp.db_version = NULL,
    metadata.isp.name = NULL,
    metadata.isp.organization = NULL
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
  AND (metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL);


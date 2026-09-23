-- STATEMENT 1: full retained range per table.
--
-- Reads INFORMATION_SCHEMA.PARTITIONS, not the tables. The stable tables have
-- require_partition_filter set, so a MIN/MAX over submission_timestamp is rejected: the
-- question "what is the earliest partition" is exactly the full scan the setting forbids.
-- PARTITIONS answers it from metadata, for free.
--
-- The scrub covers ALL historical data, not the cutover window. The date slicing in 08 is
-- only for cost and resumability, and the slices must together cover
-- earliest_date..CURRENT_DATE.

SELECT 'firefox_desktop_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.firefox_desktop_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('quick_suggest_v1', 'urlbar_keyword_exposure_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_firefox_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_firefox_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1', 'fx_suggest_api_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_firefox_beta_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1', 'fx_suggest_api_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_fenix_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1', 'fx_suggest_api_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_fenix_nightly_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1', 'fx_suggest_api_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_fennec_aurora_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1', 'fx_suggest_api_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_ios_firefox_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_ios_firefox_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_ios_firefoxbeta_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
UNION ALL
SELECT 'org_mozilla_ios_fennec_stable' AS dataset, table_name,
       MIN(PARSE_DATE('%Y%m%d', partition_id)) AS earliest_date,
       MAX(PARSE_DATE('%Y%m%d', partition_id)) AS latest_date,
       SUM(total_rows) AS rows_total
FROM `moz-fx-data-shared-prod.org_mozilla_ios_fennec_stable.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name IN ('fx_suggest_v1')
  AND REGEXP_CONTAINS(partition_id, r'^\d{8}$')
GROUP BY dataset, table_name
ORDER BY dataset, table_name;


-- STATEMENT 2: rows still carrying geo or isp, per table per day.
--
-- Uses a half open timestamp range rather than DATE(submission_timestamp) BETWEEN, since
-- the latter is not always accepted for partition elimination.
--
-- Bounds are the full measured span from statement 1, run on 2026-09-23. Earliest across
-- all tables is 2024-08-09 (the three iOS tables); end is 2026-09-24 so 09-23 is included
-- once copy_deduplicate has promoted it. Narrow them when spot checking a single table.

SELECT 'firefox_desktop' AS namespace, 'quick_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.firefox_desktop_stable.quick_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'firefox_desktop' AS namespace, 'urlbar_keyword_exposure' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.firefox_desktop_stable.urlbar_keyword_exposure_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox' AS namespace, 'fx_suggest_api' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_api_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox_beta' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_firefox_beta' AS namespace, 'fx_suggest_api' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_api_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix' AS namespace, 'fx_suggest_api' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_api_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix_nightly' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fenix_nightly' AS namespace, 'fx_suggest_api' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_api_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fennec_aurora' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_fennec_aurora' AS namespace, 'fx_suggest_api' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_api_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_ios_firefox' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_ios_firefox_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_ios_firefoxbeta' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
UNION ALL
SELECT 'org_mozilla_ios_fennec' AS namespace, 'fx_suggest' AS doctype,
       DATE(submission_timestamp) AS dt,
       COUNT(*) AS rows_total,
       COUNTIF(metadata.geo.city IS NOT NULL OR metadata.geo.country IS NOT NULL OR metadata.geo.db_version IS NOT NULL OR metadata.geo.subdivision1 IS NOT NULL OR metadata.geo.subdivision2 IS NOT NULL OR metadata.isp.db_version IS NOT NULL OR metadata.isp.name IS NOT NULL OR metadata.isp.organization IS NOT NULL) AS rows_dirty
FROM `moz-fx-data-shared-prod.org_mozilla_ios_fennec_stable.fx_suggest_v1`
WHERE submission_timestamp >= TIMESTAMP('2024-08-09 00:00:00')
  AND submission_timestamp <  TIMESTAMP('2026-09-24 00:00:00')
GROUP BY dt
ORDER BY namespace, doctype, dt;

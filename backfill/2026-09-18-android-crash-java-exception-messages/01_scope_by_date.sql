-- Step 1: per table, per submission_date, count rows still carrying Java
-- exception messages. Counts only -- never selects a message value (that is
-- the data being removed).
--
-- Doubles as the post-scrub check: after step 2, this must return no rows.
--
-- A row is affected iff any of the three message locations is present, in
-- either of the two fields. See 02_scrub.sql for the structure notes.
--
-- The date filter is applied once below the UNION rather than repeated in
-- every branch. BigQuery pushes it down into each scan: verified identical
-- bytes processed and identical results against the per-branch form, and it
-- satisfies require_partition_filter on all of these tables.
CREATE TEMP FUNCTION needs_java_exception_scrub(j JSON) AS ((
  SELECT JSON_QUERY(j, '$.messages') IS NOT NULL
      OR EXISTS(SELECT 1 FROM UNNEST(JSON_QUERY_ARRAY(j, '$.throwables')) AS e
                WHERE JSON_QUERY(e, '$.message') IS NOT NULL)
      OR EXISTS(SELECT 1 FROM UNNEST(JSON_QUERY_ARRAY(j, '$.exception.values')) AS v
                WHERE JSON_QUERY(v, '$.stacktrace.value') IS NOT NULL)
));

CREATE TEMP FUNCTION needs_meta_annotations_scrub(ma JSON) AS ((
  SELECT needs_java_exception_scrub(
    SAFE.PARSE_JSON(JSON_VALUE(SAFE.PARSE_JSON(JSON_VALUE(ma, '$.source')), '$.JavaException')))
));

WITH u AS (
  SELECT 'org_mozilla_firefox_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_firefox_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_firefox_beta_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_firefox_beta_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fenix_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fenix_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fenix_nightly_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fenix_nightly_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fennec_aurora_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fennec_aurora_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_focus_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_focus_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_beta_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_focus_beta_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_beta_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_focus_beta_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_nightly_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_focus_nightly_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_nightly_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_focus_nightly_live.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_klar_stable.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_klar_stable.crash_v1`
  UNION ALL
  SELECT 'org_mozilla_klar_live.crash_v1' AS source_table, submission_timestamp,
         metrics.object.crash_java_exception AS cje, metrics.object.meta_annotations AS ma
  FROM `moz-fx-data-shared-prod.org_mozilla_klar_live.crash_v1`
  UNION ALL
  -- Derived table: Android rows only. The query hardcodes normalized_app_id to
  -- NULL for its two desktop branches, so naming the Android app ids keeps
  -- desktop out and prunes on the leading clustering column. This predicate is
  -- specific to this branch; the date filter is still applied below.
  SELECT 'telemetry_derived.firefox_crashes_v1', submission_timestamp,
         metrics.object.crash_java_exception, metrics.object.meta_annotations
  FROM `moz-fx-data-shared-prod.telemetry_derived.firefox_crashes_v1`
  WHERE normalized_app_id IN (
    'org_mozilla_firefox', 'org_mozilla_firefox_beta', 'org_mozilla_fenix',
    'org_mozilla_fenix_nightly', 'org_mozilla_fennec_aurora',
    'org_mozilla_focus', 'org_mozilla_focus_beta', 'org_mozilla_focus_nightly',
    'org_mozilla_klar')
)
SELECT
  source_table,
  DATE(submission_timestamp) AS submission_date,
  COUNT(*) AS rows_in_partition,
  COUNTIF(needs_java_exception_scrub(cje)) AS affected_crash_java_exception,
  COUNTIF(needs_meta_annotations_scrub(ma)) AS affected_meta_annotations,
  COUNTIF(needs_java_exception_scrub(cje) OR needs_meta_annotations_scrub(ma)) AS affected_rows
FROM u
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
GROUP BY source_table, submission_date
HAVING affected_rows > 0
ORDER BY source_table, submission_date

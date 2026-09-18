-- Affected crash-ping error rows per app per day.
--
-- The errors.structured_* tables are views over payload_bytes_error.structured,
-- one per document namespace, so the apps have to be unioned explicitly. The
-- base table is clustered only on submission_timestamp, so the namespace filter
-- does not prune and the date bounds are what control how much gets read.
--
-- payload is gzipped BYTES holding the raw submitted ping, where object metrics
-- keep their dotted Glean names ("crash.java_exception", "meta.annotations")
-- rather than the snake_case BigQuery column names. JSONPath needs double
-- quotes for keys containing dots; bracket syntax is rejected.
--
-- Roughly 10% of these payloads are not parseable as JSON (that is often why
-- they errored), and the structural check silently misses those. The substring
-- column covers them, so affected_total is what to act on.

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

WITH raw AS (
  SELECT 'org_mozilla_firefox' AS app, submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_firefox__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_firefox_beta', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_firefox_beta__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fenix', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_fenix__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fenix_nightly', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_fenix_nightly__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_fennec_aurora', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_fennec_aurora__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_focus__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_beta', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_focus_beta__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_focus_nightly', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_focus_nightly__crash_v1`
  UNION ALL
  SELECT 'org_mozilla_klar', submission_timestamp, error_type, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_klar__crash_v1`
),
decoded AS (
  SELECT app, DATE(submission_timestamp) AS dt, error_type,
         `moz-fx-data-shared-prod.udf_js.gunzip`(payload) AS txt
  FROM raw
  WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
),
parsed AS (
  SELECT d.*, SAFE.PARSE_JSON(txt) AS ping FROM decoded AS d
),
flagged AS (
  SELECT
    app, dt, error_type, txt, ping,
    needs_java_exception_scrub(
      JSON_QUERY(ping, '$.metrics.object."crash.java_exception"')) AS cje_affected,
    needs_meta_annotations_scrub(
      JSON_QUERY(ping, '$.metrics.object."meta.annotations"')) AS ma_affected
  FROM parsed
)
SELECT
  app,
  dt,
  COUNT(*) AS error_rows,
  COUNTIF(cje_affected) AS affected_crash_java_exception,
  COUNTIF(ma_affected) AS affected_meta_annotations,
  -- payload could not be parsed, but the metric name is present as text
  COUNTIF(ping IS NULL AND STRPOS(txt, 'crash.java_exception') > 0) AS affected_unparseable,
  COUNTIF(
    cje_affected
    OR ma_affected
    OR (ping IS NULL AND STRPOS(txt, 'crash.java_exception') > 0)
  ) AS affected_total,
  STRING_AGG(DISTINCT error_type ORDER BY error_type) AS error_types
FROM flagged
GROUP BY app, dt
HAVING affected_total > 0
ORDER BY dt, app

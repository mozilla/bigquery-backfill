-- Removes Java exception messages from Android crash pings. Idempotent:
-- re-running is a no-op once the paths are gone.
--
-- Set the date bounds below; both ends are inclusive. DML bills every byte in
-- the partitions it modifies, not just the matched rows, so work through a long
-- history a month at a time rather than covering the full retention window in
-- one statement.
--
-- A row passes through unchanged when $.source or JavaException cannot be
-- parsed, rather than having the field dropped. That was verified to affect no
-- rows across Android crash history, but re-check before widening the range,
-- using the preflight query at the end of this file.

-- Strips every known Java exception message location from any
-- java-exception-shaped object, wherever that object appears.
--   $.messages
--   $.throwables[].message
--   $.exception.values[].stacktrace.value
CREATE TEMP FUNCTION remove_java_exception_messages(j JSON) AS ((
  SELECT
    CASE
      WHEN j IS NULL OR JSON_TYPE(j) != 'object' THEN j
      ELSE (
        SELECT
          CASE
            WHEN JSON_TYPE(JSON_QUERY(j2, '$.exception.values')) = 'array' THEN
              JSON_SET(j2, '$.exception.values', (
                SELECT TO_JSON(IFNULL(ARRAY_AGG(JSON_REMOVE(v, '$.stacktrace.value') ORDER BY o), ARRAY<JSON>[]))
                FROM UNNEST(JSON_QUERY_ARRAY(j2, '$.exception.values')) AS v WITH OFFSET o
              ))
            ELSE j2
          END
        FROM (
          SELECT
            CASE
              WHEN JSON_TYPE(JSON_QUERY(j, '$.throwables')) = 'array' THEN
                JSON_SET(JSON_REMOVE(j, '$.messages'), '$.throwables', (
                  SELECT TO_JSON(IFNULL(ARRAY_AGG(JSON_REMOVE(e, '$.message') ORDER BY o), ARRAY<JSON>[]))
                  FROM UNNEST(JSON_QUERY_ARRAY(j, '$.throwables')) AS e WITH OFFSET o
                ))
              ELSE JSON_REMOVE(j, '$.messages')
            END AS j2
        )
      )
    END
));

CREATE TEMP FUNCTION needs_java_exception_scrub(j JSON) AS ((
  SELECT JSON_QUERY(j, '$.messages') IS NOT NULL
      OR EXISTS(SELECT 1 FROM UNNEST(JSON_QUERY_ARRAY(j, '$.throwables')) AS e
                WHERE JSON_QUERY(e, '$.message') IS NOT NULL)
      OR EXISTS(SELECT 1 FROM UNNEST(JSON_QUERY_ARRAY(j, '$.exception.values')) AS v
                WHERE JSON_QUERY(v, '$.stacktrace.value') IS NOT NULL)
));

-- meta_annotations is double-encoded: $.source is a JSON string whose
-- JavaException key is itself a JSON string. Re-serialize both levels.
CREATE TEMP FUNCTION scrub_meta_annotations(ma JSON) AS ((
  SELECT
    CASE
      WHEN src IS NULL OR je IS NULL THEN ma
      ELSE JSON_SET(ma, '$.source',
             TO_JSON_STRING(JSON_SET(src, '$.JavaException',
               TO_JSON_STRING(remove_java_exception_messages(je)))))
    END
  FROM (
    SELECT src, SAFE.PARSE_JSON(JSON_VALUE(src, '$.JavaException')) AS je
    FROM (SELECT SAFE.PARSE_JSON(JSON_VALUE(ma, '$.source')) AS src)
  )
));

CREATE TEMP FUNCTION needs_meta_annotations_scrub(ma JSON) AS ((
  SELECT needs_java_exception_scrub(
    SAFE.PARSE_JSON(JSON_VALUE(SAFE.PARSE_JSON(JSON_VALUE(ma, '$.source')), '$.JavaException')))
));

-- One statement per stable and live table, then the derived table last.

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_firefox_beta_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_focus_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_focus_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_focus_beta_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_focus_beta_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_focus_nightly_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_focus_nightly_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_klar_stable.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

UPDATE `moz-fx-data-shared-prod.org_mozilla_klar_live.crash_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

-- Derived table. Android rows only: the query hardcodes normalized_app_id to NULL for the
-- two desktop branches, so naming the Android app ids keeps desktop untouched
UPDATE `moz-fx-data-shared-prod.telemetry_derived.firefox_crashes_v1` AS t
SET metrics.object.crash_java_exception = remove_java_exception_messages(t.metrics.object.crash_java_exception),
    metrics.object.meta_annotations     = scrub_meta_annotations(t.metrics.object.meta_annotations)
WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND '2026-09-18'
  AND (needs_java_exception_scrub(t.metrics.object.crash_java_exception)
       OR needs_meta_annotations_scrub(t.metrics.object.meta_annotations));

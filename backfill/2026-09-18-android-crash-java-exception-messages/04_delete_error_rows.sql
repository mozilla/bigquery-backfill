-- Delete crash-ping error rows whose payload carries Java exception messages.
--
-- Run against payload_bytes_error.structured directly. The errors.structured_*
-- tables are views and cannot be deleted through. Note the base table spells
-- namespaces with hyphens, while the view names use underscores.
--
-- Deliberately split into identify / review / delete rather than putting the
-- gunzip and JSON predicate in the DELETE itself. A destructive statement on a
-- shared pipeline table should not re-derive its own target set: pin the rows
-- to a hash list, check the count, then delete against the list. That also
-- keeps the JS UDF out of the DML.
--
-- payload MD5 was verified unique across the affected rows (46 rows, 46
-- distinct hashes), and the step 3 predicate was verified to match exactly
-- those 46 of the 164 rows in the affected partitions. Two rows have payloads
-- that are not valid JSON but contain the metric name as text; they are
-- included, since they cannot be cleared any other way.

-- ---------------------------------------------------------------------------
-- Step 1: identify. Read-only derivation into a small key table. Holds only
-- timestamps and payload hashes, no payload content.
-- ---------------------------------------------------------------------------
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

CREATE OR REPLACE TABLE `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys`
OPTIONS (expiration_timestamp = TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 14 DAY))
AS
WITH raw AS (
  SELECT 'org-mozilla-firefox' AS document_namespace, submission_timestamp, uri, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_firefox__crash_v1`
  UNION ALL
  SELECT 'org-mozilla-firefox-beta', submission_timestamp, uri, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_firefox_beta__crash_v1`
  UNION ALL
  SELECT 'org-mozilla-fenix', submission_timestamp, uri, payload
  FROM `moz-fx-data-shared-prod.errors.structured_org_mozilla_fenix__crash_v1`
),
decoded AS (
  SELECT document_namespace, submission_timestamp, uri,
         TO_BASE64(MD5(payload)) AS payload_md5,
         `moz-fx-data-shared-prod.udf_js.gunzip`(payload) AS txt
  FROM raw
  WHERE DATE(submission_timestamp) BETWEEN '2024-08-01' AND CURRENT_DATE()
),
parsed AS (
  SELECT d.*, SAFE.PARSE_JSON(txt) AS ping FROM decoded AS d
)
SELECT document_namespace, submission_timestamp, uri, payload_md5
FROM parsed
WHERE needs_java_exception_scrub(JSON_QUERY(ping, '$.metrics.object."crash.java_exception"'))
   OR needs_meta_annotations_scrub(JSON_QUERY(ping, '$.metrics.object."meta.annotations"'))
   OR (ping IS NULL AND STRPOS(txt, 'crash.java_exception') > 0);

-- ---------------------------------------------------------------------------
-- Step 2: review before deleting. rows_matched must equal key_rows. If it is
-- larger, the hash is over-matching and the DELETE would take innocent rows.
-- ---------------------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys`) AS key_rows,
  COUNT(*) AS rows_matched
FROM `moz-fx-data-shared-prod.payload_bytes_error.structured` AS t
WHERE DATE(t.submission_timestamp) IN (
        SELECT DISTINCT DATE(submission_timestamp)
        FROM `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys`)
  AND t.document_type = 'crash'
  AND t.document_version = '1'
  AND t.document_namespace IN (
        'org-mozilla-firefox', 'org-mozilla-firefox-beta', 'org-mozilla-fenix')
  AND EXISTS (
        SELECT 1 FROM `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys` k
        WHERE k.submission_timestamp = t.submission_timestamp
          AND k.payload_md5 = TO_BASE64(MD5(t.payload)));

-- ---------------------------------------------------------------------------
-- Step 3: delete. The date IN list satisfies require_partition_filter and
-- confines the rewrite to the affected partitions.
-- ---------------------------------------------------------------------------
DELETE FROM `moz-fx-data-shared-prod.payload_bytes_error.structured` AS t
WHERE DATE(t.submission_timestamp) IN (
        SELECT DISTINCT DATE(submission_timestamp)
        FROM `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys`)
  AND t.document_type = 'crash'
  AND t.document_version = '1'
  AND t.document_namespace IN (
        'org-mozilla-firefox', 'org-mozilla-firefox-beta', 'org-mozilla-fenix')
  AND EXISTS (
        SELECT 1 FROM `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys` k
        WHERE k.submission_timestamp = t.submission_timestamp
          AND k.payload_md5 = TO_BASE64(MD5(t.payload)));

-- ---------------------------------------------------------------------------
-- Step 4: verify. Re-run scratch/affected_error_rows_by_app_day.sql; it should
-- return no rows. Then drop the key table.
-- ---------------------------------------------------------------------------
--   DROP TABLE `moz-fx-data-shared-prod.analysis.benwu_affected_error_keys`;

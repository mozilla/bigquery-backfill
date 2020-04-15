WITH distinct_document_ids AS (
  SELECT
    document_id,
    MIN(submission_timestamp) AS submission_timestamp
  FROM
    `moz-fx-data-shared-prod.payload_bytes_decoded.telemetry_telemetry__main_v4`
  WHERE
    DATE(submission_timestamp) = '2020-04-14'
  GROUP BY
    document_id
),
base AS (
  SELECT
    *
  FROM
    `moz-fx-data-shared-prod.payload_bytes_decoded.telemetry_telemetry__main_v4`
  JOIN
    distinct_document_ids
  USING
    (document_id, submission_timestamp)
  WHERE
    DATE(submission_timestamp) = '2020-04-14'
),
numbered_duplicates AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY document_id) AS _n
  FROM
    base
)
SELECT
  * EXCEPT (_n)
FROM
  numbered_duplicates
WHERE
  _n = 1

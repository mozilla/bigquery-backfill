WITH
  errors AS (
  SELECT
    DISTINCT document_id
  FROM
    `moz-fx-data-backfill-31.activity_stream_stable.events_v1`
  WHERE
    DATE(submission_timestamp) = "2020-02-24" ),
  prod AS (
  SELECT
    DISTINCT document_id
  FROM
    `moz-fx-data-shared-prod.activity_stream_stable.events_v1`
  WHERE
    DATE(submission_timestamp) = "2020-02-24" ),
  joined AS (
  SELECT
    "2020-02-24" AS submission_date,
    COUNT(DISTINCT document_id) AS n_seen,
  FROM
    errors
  LEFT JOIN
    prod
  USING
    (document_id)
  WHERE
    prod.document_id IS NOT NULL ),
  total AS (
  SELECT
    "2020-02-24" AS submission_date,
    COUNT(*) n_errors
  FROM
    errors )
SELECT
  *
FROM
  total
JOIN
  joined
USING
  (submission_date)
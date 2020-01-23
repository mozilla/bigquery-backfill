WITH ids AS (
  SELECT
    DATE(submission_timestamp) AS dt,
    document_id
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.crash_v4`
  WHERE
    DATE(submission_timestamp)
    BETWEEN '2019-12-04'
    AND '2020-01-09'
  UNION ALL
  SELECT
    DATE(submission_timestamp) AS dt,
    document_id
  FROM
    `moz-fx-data-backfill-2.telemetry_stable.crash_v4`
  WHERE
    DATE(submission_timestamp)
    BETWEEN '2019-12-04'
    AND '2020-01-09'
),
dupes AS (
  SELECT
    dt,
    document_id,
    COUNT(*) AS n
  FROM
    ids
  GROUP BY
    1,
    2
  HAVING
    n > 1
)
SELECT
  *
FROM
  `moz-fx-data-backfill-2.telemetry_stable.crash_v4`
WHERE
  document_id NOT IN (SELECT document_id FROM dupes)

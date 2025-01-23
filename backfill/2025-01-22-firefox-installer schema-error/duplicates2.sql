WITH backfill AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    document_id,
  FROM
    `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
  WHERE
    DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
  QUALIFY
    ROW_NUMBER() OVER (PARTITION BY document_id, submission_date ORDER BY submission_timestamp) = 1
),
stable AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    document_id,
    build_channel,
  FROM
    `moz-fx-data-shared-prod.firefox_installer_stable.install_v1`
  WHERE
    DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
)

SELECT
  submission_date,
  document_id,
  build_channel,
FROM
  backfill
INNER JOIN
  stable
USING
  (document_id, submission_date)
ORDER BY
  document_id,
  submission_date

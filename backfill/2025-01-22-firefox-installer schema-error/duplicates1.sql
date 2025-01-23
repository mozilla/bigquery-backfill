SELECT
  document_id
FROM
  `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY document_id, DATE(submission_timestamp) ORDER BY submission_timestamp) > 1

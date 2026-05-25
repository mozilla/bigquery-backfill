-- Dedupe the dataflow output by document_id (per day, matching copy_deduplicate
-- semantics) and exclude any document_ids that are already present in the prod
-- stable table for the same day. The result should be written to
-- `moz-fx-data-backfill-1.firefox_desktop_stable.baseline_v1` using:
--
--   bq query \
--     --use_legacy_sql=false \
--     --destination_table='moz-fx-data-backfill-1:firefox_desktop_stable.baseline_v1' \
--     --replace=true \
--     "$(cat dedupe.sql)"
--
-- Incident window confirmed via affected_pings.sql: rejections occurred only on
-- 2026-05-19 and 2026-05-20 (zero rejections from 2026-05-21 onward).

WITH backfill AS (
  SELECT
    *
  FROM
    `moz-fx-data-backfill-1.firefox_desktop_live.baseline_v1`
  WHERE
    DATE(submission_timestamp) BETWEEN '2026-05-19' AND '2026-05-20'
  QUALIFY
    ROW_NUMBER() OVER (
      PARTITION BY document_id, DATE(submission_timestamp)
      ORDER BY submission_timestamp
    ) = 1
),
stable AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    document_id
  FROM
    `moz-fx-data-shared-prod.firefox_desktop_stable.baseline_v1`
  WHERE
    DATE(submission_timestamp) BETWEEN '2026-05-19' AND '2026-05-20'
)
SELECT
  backfill.*
FROM
  backfill
LEFT JOIN
  stable
ON
  backfill.document_id = stable.document_id
  AND DATE(backfill.submission_timestamp) = stable.submission_date
WHERE
  stable.submission_date IS NULL

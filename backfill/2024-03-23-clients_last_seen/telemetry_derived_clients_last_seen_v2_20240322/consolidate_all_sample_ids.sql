MERGE `mozdata.analysis.clients_last_seen_v2_including_active_bits` AS t
USING 
(
  SELECT 
  a.submission_date, 
  a.client_id,
  b.days_active_bits, 
  IF(c.first_seen_date > a.submission_date, NULL, c.first_seen_date) AS first_seen_date, 
  IF(c.second_seen_date > a.submission_date, NULL, c.second_seen_date) AS second_seen_date
  FROM 
  (
    SELECT
      submission_date, client_id 
    FROM `mozdata.analysis.clients_last_seen_v2_including_active_bits`
      AND client_id IS NOT NULL
      AND submission_date IS NOT NULL
  ) a
  LEFT JOIN 
    `moz-fx-data-shared-prod.analysis.clients_last_seen_v2_days_active_bits` b 
    ON a.client_id = b.client_id
    AND a.submission_date = b.submission_date
  LEFT JOIN 
    `moz-fx-data-shared-prod.telemetry_derived.clients_first_seen_v2` c 
    ON a.client_id = c.client_id
) AS s
ON t.client_id = S.client_id 
AND t.submission_date = S.submission_date
WHEN MATCHED 
THEN UPDATE 
SET t.days_active_bits = S.days_active_bits,
t.first_seen_date = S.first_seen_date,
t.second_seen_date = S.second_seen_date;

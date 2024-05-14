-- Query
WITH _current AS (
    SELECT
    CAST(TRUE AS INT64) AS days_seen_bits,
    CAST(active_hours_sum > 0 AS INT64) & CAST(
      COALESCE(
        scalar_parent_browser_engagement_total_uri_count_normal_and_private_mode_sum,
        scalar_parent_browser_engagement_total_uri_count_sum
      ) > 0 AS INT64
    ) AS days_active_bits,
    client_id
  FROM
    `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6`
  WHERE
    submission_date = @submission_date
    AND client_id IS NOT NULL
),
_previous AS (
  SELECT
    days_seen_bits,
    days_active_bits,
    client_id
  FROM
    `moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v2_days_active_bits` --fix this
  WHERE
    submission_date = DATE_SUB(@submission_date, INTERVAL 1 DAY)
    AND udf.shift_28_bits_one_day(days_seen_bits) > 0
)
SELECT
  @submission_date AS submission_date,
  IF(_current.client_id IS NOT NULL, _current, _previous).*
  REPLACE (
    udf.combine_adjacent_days_28_bits(
      _previous.days_seen_bits,
      _current.days_seen_bits
    ) AS days_seen_bits,
    udf.combine_adjacent_days_28_bits(
      _previous.days_active_bits,
      _current.days_active_bits
    ) AS days_active_bits
  )
FROM
  _current
FULL JOIN
  _previous
  USING (client_id)


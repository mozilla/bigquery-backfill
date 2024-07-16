-- Query to backfill from '2021-01-01' until '2023-12-31'
-- This query uses the metrics ping to retrieve the distribution_id for completeness in this period.
WITH distribution_id AS
(
  SELECT
    client_info.client_id,
    ARRAY_AGG(
      metrics.string.metrics_distribution_id IGNORE NULLS
      ORDER BY
        submission_timestamp ASC
    )[SAFE_OFFSET(0)] AS distribution_id
  FROM
    `moz-fx-data-shared-prod.fenix.metrics`
  WHERE
    DATE(submission_timestamp) BETWEEN DATE_SUB(@submission_date, INTERVAL 35 DAY) AND DATE_ADD(@submission_date, INTERVAL 7 DAY) --  Look back 28 days to cover all client_ids relevant to mau, adding 7 days before and after the submission_date to cover more pings in order to determine the distribution_id.
  GROUP BY
    client_id
),
baseline AS (
  SELECT
    activity_segment AS segment,
    attribution_medium,
    attribution_source,
    attribution_medium IS NOT NULL
    OR attribution_source IS NOT NULL AS attributed,
    city,
    country,
    dist.distribution_id AS distribution_id,
    um.first_seen_date AS first_seen_date,
    is_default_browser,
    normalized_channel AS channel,
    normalized_os AS os,
    normalized_os_version AS os_version,
    os_version_major,
    os_version_minor,
    um.submission_date,
    um.locale,
    att.adjust_network,
    att.install_source,
    normalized_app_name as app_name,
    days_since_seen,
    ad_click,
    organic_search_count,
    search_count,
    search_with_ads,
    uri_count,
    active_hours_sum,
    um.app_version as app_version,
    um.client_id,
    durations
  FROM
    `moz-fx-data-shared-prod.telemetry_derived.unified_metrics_v1` AS um
  LEFT JOIN
    distribution_id AS dist
  ON
    um.client_id = dist.client_id
  LEFT JOIN
    fenix.firefox_android_clients AS att
  ON
    um.client_id = att.client_id
  WHERE
    um.submission_date BETWEEN DATE_SUB(@submission_date, INTERVAL 28 DAY) AND @submission_date
    AND normalized_app_name IN ('Fenix', 'Fenix BrowserStack')
),
um_dau AS (
  SELECT
    submission_date,
    client_id,
    (
      LOGICAL_AND(days_since_seen = 0) AND LOGICAL_AND(durations > 0)
    ) AS is_dau
  FROM baseline
  GROUP BY ALL
),
um_is_active AS (
  SELECT
    submission_date,
    client_id,
    is_dau,
    LOGICAL_OR(is_dau) OVER (PARTITION BY client_id ORDER BY submission_date ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS is_wau,
    LOGICAL_OR(is_dau) OVER (PARTITION BY client_id ORDER BY submission_date ASC ROWS BETWEEN 27 PRECEDING AND CURRENT ROW) AS is_mau,
  FROM um_dau
)
SELECT
  segment,
  app_version,
  attribution_medium,
  attribution_source,
  attributed,
  city,
  country,
  distribution_id,
  EXTRACT(YEAR FROM first_seen_date) AS first_seen_year,
  is_default_browser,
  COALESCE(REGEXP_EXTRACT(locale, r'^(.+?)-'), locale, NULL) AS locale,
  CASE
    WHEN app_name = 'Fenix' AND distribution_id = 'MozillaOnline'
      THEN CONCAT(app_name, ' ', distribution_id)
    ELSE app_name
  END AS app_name,
  channel,
  os,
  os_version,
  os_version_major,
  os_version_minor,
  submission_date,
  adjust_network,
  install_source,
  COUNTIF(is_dau) AS dau,
  COUNTIF(is_wau) AS wau,
  COUNTIF(is_mau) AS mau,
  COUNT(DISTINCT IF(days_since_seen = 0, client_id, NULL)) AS daily_users,
  COUNT(DISTINCT IF(days_since_seen < 7, client_id, NULL)) AS weekly_users,
  COUNT(DISTINCT IF(days_since_seen < 28, client_id, NULL)) AS monthly_users,
  SUM(uri_count) AS uri_count,
  SUM(active_hours_sum) AS active_hours
FROM
  baseline
LEFT JOIN
  um_is_active USING(submission_date, client_id)
WHERE
  submission_date = @submission_date
GROUP BY
  ALL

WITH baseline AS (
  SELECT
    activity_segment AS segment,
    attribution_medium,
    attribution_source,
    attribution_medium IS NOT NULL
    OR attribution_source IS NOT NULL AS attributed,
    city,
    country,
    um.distribution_id AS distribution_id,
    um.first_seen_date AS first_seen_date,
    is_default_browser,
    normalized_channel AS channel,
    normalized_os AS os,
    normalized_os_version AS os_version,
    os_version_major,
    os_version_minor,
    um.submission_date,
    um.locale,
    CAST(NULL AS STRING) AS adjust_network,
    CAST(NULL AS STRING) AS install_source,
    normalized_app_name as app_name,
    days_since_seen,
    uri_count,
    active_hours_sum,
    um.app_version as app_version,
    um.client_id,
    isp,
    durations
  FROM
    `moz-fx-data-shared-prod.telemetry_derived.unified_metrics_v1` AS um
  WHERE
    um.submission_date = @submission_date
    AND normalized_app_name = 'Firefox Desktop'
)
SELECT
  segment,
  CASE
    WHEN app_name = 'Firefox Desktop' AND isp = 'BrowserStack'
      THEN CONCAT(app_name, ' ', isp)
    WHEN app_name = 'Firefox Desktop' AND distribution_id = 'MozillaOnline'
      THEN CONCAT(app_name, ' ', distribution_id)
    ELSE app_name
  END AS app_name,
  app_version,
  channel,
  country,
  city,
  COALESCE(REGEXP_EXTRACT(locale, r'^(.+?)-'), locale, NULL) AS locale,
  EXTRACT(YEAR FROM first_seen_date) AS first_seen_year,
  os,
  os_version,
  os_version_major,
  os_version_minor,
  submission_date,
  is_default_browser,
  distribution_id,
  attribution_source,
  attribution_medium,
  attributed,
  COUNT(DISTINCT IF(days_since_seen = 0, client_id, NULL)) AS daily_users,
  COUNT(DISTINCT IF(days_since_seen < 7, client_id, NULL)) AS weekly_users,
  COUNT(DISTINCT client_id) AS monthly_users,
  COUNT(
    DISTINCT IF(days_since_seen = 0 AND active_hours_sum > 0 AND uri_count > 0, client_id, NULL)
  ) AS dau,
  COUNT(DISTINCT IF(days_since_seen < 7 AND active_hours_sum > 0 AND uri_count > 0, client_id, NULL)) AS wau,
  COUNT(DISTINCT IF(active_hours_sum > 0 AND uri_count > 0, client_id, NULL)) AS mau,
  SUM(uri_count) AS uri_count,
  SUM(active_hours_sum) AS active_hours
FROM
  baseline
GROUP BY
  ALL

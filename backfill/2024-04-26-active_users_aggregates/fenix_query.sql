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
    fenix.firefox_android_clients AS att
  ON
    um.client_id = att.client_id
  WHERE
    um.submission_date = @submission_date
    AND normalized_app_name IN ('Fenix', 'Fenix BrowserStack')
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
    WHEN app_name = 'Fenix' AND isp = 'BrowserStack'
      THEN CONCAT(app_name, ' ', isp)
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
  COUNT(DISTINCT IF(days_since_seen = 0, client_id, NULL)) AS daily_users,
  COUNT(DISTINCT IF(days_since_seen < 7, client_id, NULL)) AS weekly_users,
  COUNT(DISTINCT client_id) AS monthly_users,
  COUNT(DISTINCT IF(days_since_seen = 0 AND durations > 0, client_id, NULL)) AS dau,
  COUNT(DISTINCT IF(days_since_seen < 7 AND durations > 0, client_id, NULL)) AS wau,
  COUNT(DISTINCT IF(durations > 0, client_id, NULL)) AS mau,
  SUM(uri_count) AS uri_count,
  SUM(active_hours_sum) AS active_hours
FROM
  baseline
GROUP BY
  ALL

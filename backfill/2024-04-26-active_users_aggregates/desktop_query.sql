WITH baseline AS
(
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
    um.submission_date AS submission_date,
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
    um.submission_date BETWEEN DATE_SUB(@submission_date, INTERVAL 28 DAY) AND @submission_date
    AND normalized_app_name = 'Firefox Desktop'
),
um_dau AS (
  SELECT
    submission_date,
    client_id,
    (
      LOGICAL_AND(uri_count > 0)
      AND LOGICAL_AND(active_hours_sum > 0)
      AND LOGICAL_AND(days_since_seen = 0)
    ) AS is_dau
  FROM baseline
  GROUP BY
    submission_date, client_id
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

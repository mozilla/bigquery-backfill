WITH baseline AS (
  SELECT
    activity_segment AS segment,
    attribution_medium,
    attribution_source,
    attribution_medium IS NOT NULL
    OR attribution_source IS NOT NULL AS attributed,
    city,
    country,
    distribution_id,
    EXTRACT(YEAR FROM um.first_seen_date) AS first_seen_year,
    is_default_browser,
    normalized_channel AS channel,
    normalized_os AS os,
    normalized_os_version AS os_version,
    os_version_major,
    os_version_minor,
    um.submission_date,
    um.locale,
    CAST(NULL AS STRING) adjust_network,
    CAST(NULL AS STRING) install_source,
    um.first_seen_date,
    normalized_app_name as app_name,
    normalized_os,
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
  WHERE
    um.submission_date >= '2021-01-01' AND um.submission_date <= CURRENT_DATE
    AND normalized_app_name IN ('Focus iOS', 'Focus iOS BrowserStack')
),
enriched_with_language AS
(
   SELECT
    baseline.* EXCEPT (locale),
    CASE
      WHEN locale IS NOT NULL
        AND languages.language_name IS NULL
        THEN 'Other'
      ELSE languages.language_name
    END AS language_name,
  FROM
    baseline
  LEFT JOIN
    `mozdata.static.csa_gblmkt_languages` AS languages
  ON
    baseline.locale = languages.code
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
  first_seen_year,
  is_default_browser,
  app_name,
  channel,
  os,
  os_version,
  os_version_major,
  os_version_minor,
  submission_date,
  adjust_network,
  install_source,
  language_name,
  COUNT(DISTINCT IF(days_since_seen = 0 AND durations > 0, client_id, NULL)) AS dau,
  COUNT(DISTINCT IF(days_since_seen = 0, client_id, NULL)) AS all_dau,
  COUNT(DISTINCT IF(days_since_seen < 7, client_id, NULL)) AS wau,
  COUNT(DISTINCT client_id) AS mau,
  COUNT(DISTINCT IF(submission_date = first_seen_date, client_id, NULL)) AS new_profiles,
  SUM(ad_click) AS ad_clicks,
  SUM(organic_search_count) AS organic_search_count,
  SUM(search_count) AS search_count,
  SUM(search_with_ads) AS search_with_ads,
  SUM(uri_count) AS uri_count,
  SUM(active_hours_sum) AS active_hours
FROM
  enriched_with_language
GROUP BY
  segment,
  distribution_id,
  channel,
  os_version,
  os_version_major,
  os_version_minor,
  language_name,
  app_name,
  app_version,
  attributed,
  attribution_medium,
  attribution_source,
  adjust_network,
  install_source,
  city,
  country,
  first_seen_year,
  is_default_browser,
  app_name,
  os,
  submission_date

CREATE TEMPORARY FUNCTION
  replace_fractional_offset(timestamp_string STRING)
  RETURNS STRING
  LANGUAGE js AS """
    // Regular expression to match fractional timezone offsets
    const regex = /([+-])(\\d{1,2})\\.(\\d{1,2}):00/;
    
    return timestamp_string.replace(regex, (match, sign, hours, fraction) => {
      const minutes = Math.floor(parseFloat('0.' + fraction) * 60); // Converts the fractional part to minutes
      return `${sign}${hours.padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
    });
""";
SELECT
  additional_properties,
  client_info,
  document_id,
  ARRAY(
  SELECT
    AS STRUCT
    CASE
      WHEN metrics.string.event_name LIKE 'email\\_%' THEN 'email'
      WHEN metrics.string.event_name LIKE 'cached\\_login\\_%' THEN 'cached_login'
      WHEN metrics.string.event_name LIKE 'cad\\_firefox\\_%' THEN 'cad_firefox'
      WHEN metrics.string.event_name LIKE 'login\\_%' THEN 'login'
      WHEN metrics.string.event_name LIKE 'password\\_reset\\_%' THEN 'password_reset'
      WHEN metrics.string.event_name LIKE 'reg\\_%' THEN 'reg'
    ELSE
    ERROR('unknown event')
  END
    AS category, ARRAY(
    SELECT
      AS STRUCT
      CASE metrics.string.event_reason
        WHEN NULL THEN NULL
      ELSE
      'reason'
    END
      AS key,
      CASE metrics.string.event_reason
        WHEN NULL THEN NULL
      ELSE
      metrics.string.event_reason
    END
      AS value ) AS extra,
    CASE
      WHEN metrics.string.event_name LIKE 'email\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'email_(.*)')
      WHEN metrics.string.event_name LIKE 'cached\\_login\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'cached_login_(.*)')
      WHEN metrics.string.event_name LIKE 'cad\\_firefox\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'cad_firefox_(.*)')
      WHEN metrics.string.event_name LIKE 'login\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'login_(.*)')
      WHEN metrics.string.event_name LIKE 'password\\_reset\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'password_reset_(.*)')
      WHEN metrics.string.event_name LIKE 'reg\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'reg_(.*)')
    ELSE
    ERROR('unknown event')
  END
    AS name, UNIX_MILLIS(mozfun.glean.parse_datetime(replace_fractional_offset(ping_info.end_time))) AS timestamp ) AS events,
  metadata,
  (
  SELECT
    AS STRUCT (
    SELECT
      AS STRUCT metrics.string.* EXCEPT (event_name,
        event_reason)) AS string,
    STRUCT (CAST(NULL AS STRING) AS glean_page_id) AS uuid,
    -- boolean metric was added to accounts-events on 7/30
    metrics.* EXCEPT (string, boolean)) AS metrics,
  normalized_app_name,
  normalized_channel,
  normalized_country_code,
  normalized_os,
  normalized_os_version,
  ping_info,
  sample_id,
  submission_timestamp
FROM
  `moz-fx-data-shared-prod.accounts_frontend_stable.accounts_events_v1`
WHERE
  DATE(submission_timestamp) = @submission_date
  AND ( metrics.string.event_name LIKE 'email\\_%'
    OR metrics.string.event_name LIKE 'cached\\_login\\_%'
    OR metrics.string.event_name LIKE 'cad\\_firefox\\_%'
    OR metrics.string.event_name LIKE 'cad\\_approve\\_device\\_%'
    OR metrics.string.event_name LIKE 'cad\\_mobile\\_pair\\_%'
    OR metrics.string.event_name LIKE 'login%'
    OR metrics.string.event_name LIKE 'password\\_reset\\_%'
    OR metrics.string.event_name LIKE 'reg%' )
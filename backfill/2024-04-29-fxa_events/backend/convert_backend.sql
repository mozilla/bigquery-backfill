SELECT
  additional_properties,
  client_info,
  document_id,
  ARRAY(
  SELECT
    AS STRUCT
    CASE
      WHEN metrics.string.event_name LIKE 'access\\_token\\_%' THEN 'access_token'
      WHEN metrics.string.event_name LIKE 'account%' THEN 'account'
      WHEN metrics.string.event_name LIKE 'login%' THEN 'login'
      WHEN metrics.string.event_name LIKE 'password\\_reset\\_%' THEN 'password_reset'
      WHEN metrics.string.event_name LIKE 'reg%' THEN 'reg'
    ELSE
    ERROR('unknown event')
  END
    AS category,
    ARRAY(
    SELECT
      AS STRUCT
      CASE metrics.string.event_reason
        WHEN NULL THEN NULL
      ELSE
      'reason'
    END
      AS KEY,
      CASE metrics.string.event_reason
        WHEN NULL THEN NULL
      ELSE
      metrics.string.event_reason
    END
      AS value ) AS extra,
    CASE
      WHEN metrics.string.event_name LIKE 'access\\_token\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'access_token_(.*)')
      WHEN metrics.string.event_name LIKE 'account%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'account_(.*)')
      WHEN metrics.string.event_name LIKE 'login%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'login_(.*)')
      WHEN metrics.string.event_name LIKE 'password\\_reset\\_%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'password_reset_(.*)')
      WHEN metrics.string.event_name LIKE 'reg%' THEN REGEXP_EXTRACT(metrics.string.event_name, r'reg_(.*)')
    ELSE
    ERROR('unknown event')
  END
    AS name,
    UNIX_MILLIS(TIMESTAMP(ping_info.end_time)) AS timestamp
  ) AS events,
  metadata,
  (
  SELECT
    AS STRUCT (
    SELECT
      AS STRUCT metrics.string.* EXCEPT (event_name,
        event_reason)) AS string,
    metrics.* EXCEPT (string)) AS metrics,
  normalized_app_name,
  normalized_channel,
  normalized_country_code,
  normalized_os,
  normalized_os_version,
  ping_info,
  sample_id,
  submission_timestamp
FROM
  `moz-fx-data-shared-prod.accounts_backend_stable.accounts_events_v1`
WHERE
  DATE(submission_timestamp) = @submission_date

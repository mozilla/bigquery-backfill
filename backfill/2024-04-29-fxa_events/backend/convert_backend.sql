SELECT
  * EXCEPT(metrics, events),
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
  UNIX_MILLIS(TIMESTAMP(ping_info.end_time)) as timestamp,
  ARRAY(SELECT AS STRUCT
  case metrics.string.event_reason
  when null then null
  else 'reason'
  end
   as key,
   case metrics.string.event_reason
  when null then null
  else metrics.string.event_reason
  end
  as value
  ) as extra
  ) AS events,
  (
  SELECT
    AS STRUCT (
    SELECT
      AS STRUCT metrics.string.* EXCEPT (event_name, event_reason)) AS string,
    metrics.* EXCEPT (string)) AS metrics
FROM
  `moz-fx-data-shared-prod.accounts_backend_stable.accounts_events_v1`
WHERE
  DATE(submission_timestamp) = @submission_date

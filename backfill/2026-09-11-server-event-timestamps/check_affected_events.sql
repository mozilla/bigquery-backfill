FROM `accounts_backend_stable.events_v1`
|> WHERE submission_timestamp < CURRENT_TIMESTAMP() AND events[0].timestamp > 0
|> AGGREGATE COUNT(*) AS affected_event_count, MIN(submission_timestamp) AS min_timestamp, MAX(submission_timestamp) AS max_timestamp
|> SELECT 'accounts_backend_stable.events_v1' AS table_id, *
|> UNION ALL
  (
    FROM `relay_backend_stable.events_v1`
    |> WHERE submission_timestamp < CURRENT_TIMESTAMP() AND events[0].timestamp > 0
    |> AGGREGATE COUNT(*) AS affected_event_count, MIN(submission_timestamp) AS min_timestamp, MAX(submission_timestamp) AS max_timestamp
    |> SELECT 'relay_backend_stable.events_v1' AS table_id, *
  ),
  (
    FROM `subscription_platform_backend_stable.events_v1`
    |> WHERE submission_timestamp < CURRENT_TIMESTAMP() AND events[0].timestamp > 0
    |> AGGREGATE COUNT(*) AS affected_event_count, MIN(submission_timestamp) AS min_timestamp, MAX(submission_timestamp) AS max_timestamp
    |> SELECT 'subscription_platform_backend_stable.events_v1' AS table_id, *
  ),
  (
    FROM `syncstorage_stable.events_v1`
    |> WHERE submission_timestamp < CURRENT_TIMESTAMP() AND events[0].timestamp > 0
    |> AGGREGATE COUNT(*) AS affected_event_count, MIN(submission_timestamp) AS min_timestamp, MAX(submission_timestamp) AS max_timestamp
    |> SELECT 'syncstorage_stable.events_v1' AS table_id, *
  )
|> ORDER BY table_id

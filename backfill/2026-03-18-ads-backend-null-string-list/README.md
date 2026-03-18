# 2026-03-18 ads_backend null string_list schema errors

Jira: https://mozilla-hub.atlassian.net/browse/DENG-10814

Slack thread: https://mozilla.slack.com/archives/C01E8GDG80N/p1773766267975129

glean_parser fix: https://github.com/mozilla/glean_parser/pull/837

## Context

A bug in glean_parser's Go server template caused nil string slices to be serialized as JSON `null` instead of `[]` (empty array). This failed Glean schema validation, which expects a JSONArray for string_list metrics. The affected payloads were dropped into the error table instead of being ingested normally.

This affects ads_backend data used for billing and customer reporting.

Affected pings: `request-stats` and `interaction` in the `ads_backend` namespace.

## Scoping

Count affected rows:
```sql
SELECT
  DATE(submission_timestamp) AS date,
  document_namespace,
  document_type,
  error_message,
  COUNT(*) AS cnt
FROM `moz-fx-data-shared-prod.monitoring.payload_bytes_error_structured`
WHERE DATE(submission_timestamp) >= '2026-03-15'
  AND document_namespace LIKE 'ads%'
GROUP BY ALL
ORDER BY date, document_namespace, document_type
```

Results — only 2026-03-17 is affected (fix was deployed before 2026-03-18):

| Ping Type | Error | Count |
|---|---|---|
| interaction | `#/metrics/string_list/ad.categories: expected type: JSONArray, found: Null` | 148,184,292 |
| request-stats | `#/metrics/string_list/ad.categories: expected type: JSONArray, found: Null` | 723,148,951 |
| **Total** | | **871,333,243** |

All errors share the same root cause: the `ad.categories` string_list metric is `Null` instead of a JSONArray.

Destination tables (in `moz-fx-data-shared-prod`):
- `ads_backend_stable.interaction_v1`
- `ads_backend_stable.request_stats_v1`


## Steps for backfill

1. Set up backfill project
2. Make changes to decoder to fix null string_list values in payloads
3. Run affected pings through decoder, writing to staging tables
4. Validate and dedupe staging table
5. Insert into prod stable table

## Set up backfill project

Copy errored rows from `payload_bytes_error` to a backfill project staging table. This will require terraform changes in cloudops-infra (similar to [cloudops-infra PR #6194](https://github.com/mozilla-services/cloudops-infra/pull/6194) for the firefox-installer backfill).

```sql
INSERT INTO `moz-fx-data-backfill-1.payload_bytes_error.backfill`
SELECT
  *
FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE DATE(submission_timestamp) = '2026-03-17'
  AND document_namespace = 'ads_backend'
```

Note: Column order may differ between source and destination tables. If so, list columns explicitly (see firefox-installer backfill for example).

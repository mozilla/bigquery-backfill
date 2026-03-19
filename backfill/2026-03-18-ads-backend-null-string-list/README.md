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

Provision the backfill project via terraform in cloudops-infra: https://github.com/mozilla-services/cloudops-infra/pull/6818.

The terraform module in `projects/data-backfill/tf/prod/projects/backfill.tf` will:
- Create `ads_backend_live`, `ads_backend_stable`, and `payload_bytes_error` datasets in `moz-fx-data-backfill-1`
- Copy error rows from `moz-fx-data-shared-prod.payload_bytes_error.structured` to `moz-fx-data-backfill-1.payload_bytes_error.backfill`

Since `ads_backend` data is access-restricted in production the backfill project editors are limited.

## Decoder changes

The payloads contain `null` where the schema expects `[]` for string_list metrics. The decoder is modified to coerce null string_list values to empty arrays before schema validation.

PR: https://github.com/mozilla/gcp-ingestion/pull/2913

## Deploy decoder job

Run from the `ingestion-beam/` directory of `gcp-ingestion`, on the branch with the decoder changes from PR #2913:

```
ingestion-beam % /path/to/start_dataflow.sh
```

See [start_dataflow.sh](./start_dataflow.sh) for the full configuration. Key settings:
- Input: `moz-fx-data-backfill-1:payload_bytes_error.backfill`
- Output: `moz-fx-data-backfill-1:${document_namespace}_live.${document_type}_v${document_version}`
- Errors: `moz-fx-data-backfill-1:payload_bytes_error.structured`
- GeoIP/schemas from 2026-03-17 to match the original ingestion date


## Validation

All input rows were successfully reprocessed with 0 errors.
Key fields are fully populated:

```sql
-- interaction: all key fields 100% populated (148,184,292 / 148,184,292)
SELECT
  COUNTIF(metrics.string.ad_country_code IS NOT NULL) AS has_country_code,
  COUNTIF(metrics.string.ad_interaction IS NOT NULL) AS has_interaction,
  COUNTIF(metrics.string.ad_advertiser IS NOT NULL) AS has_advertiser,
  COUNT(*) AS total
FROM `moz-fx-data-backfill-1.ads_backend_live.interaction_v1`
WHERE DATE(submission_timestamp) = '2026-03-17'

-- request_stats: all key fields 100% populated (723,148,951 / 723,148,951)
SELECT
  COUNTIF(metrics.string.ad_country_code IS NOT NULL) AS has_country_code,
  COUNTIF(metrics.quantity.technical_operations_count_requested IS NOT NULL) AS has_count_requested,
  COUNTIF(metrics.quantity.technical_operations_count_returned IS NOT NULL) AS has_count_returned,
  COUNT(*) AS total
FROM `moz-fx-data-backfill-1.ads_backend_live.request_stats_v1`
WHERE DATE(submission_timestamp) = '2026-03-17'
```

The `ad.categories` field is stored as NULL in BQ, which is expected since BigQuery represents empty arrays as NULL.

`additional_properties` is empty for all rows in both tables (no data loss from schema mismatch):

```sql
-- interaction: 0 non-empty additional_properties
SELECT
  COUNTIF(additional_properties IS NOT NULL AND additional_properties != '{}') AS non_empty,
  COUNT(*) AS total
FROM `moz-fx-data-backfill-1.ads_backend_live.interaction_v1`
WHERE DATE(submission_timestamp) = '2026-03-17'

-- request_stats: 0 non-empty additional_properties
SELECT
  COUNTIF(additional_properties IS NOT NULL AND additional_properties != '{}') AS non_empty,
  COUNT(*) AS total
FROM `moz-fx-data-backfill-1.ads_backend_live.request_stats_v1`
WHERE DATE(submission_timestamp) = '2026-03-17'
```

## Copy to stable with document_id generation

The decoder outputs NULL `document_id` for all rows because the `payload_bytes_error` table does not have
a `document_id` column and the `uri` is also NULL for these server-side pings. The original UUIDs generated
by the mars server (see [server_events.go](https://github.com/mozilla-services/mars/blob/7c0981d4a924d0d01e9d45a9afd379aca53a5eda/internal/logging/glean/server_events.go#L127))
are not recoverable.

Deduplication is not needed — this is server-side telemetry which does not produce duplicate pings.
For consistency with existing data we generate new random UUIDs when copying to stable to match the production data pattern.

Note: There is a theoretical risk of UUID collisions with existing prod data. With ~2 billion total UUIDs
and 122 bits of randomness in v4 UUIDs, the collision probability is ~10^-19 — effectively zero.

```sql
-- interaction
INSERT INTO `moz-fx-data-backfill-1.ads_backend_stable.interaction_v1`
SELECT
  additional_properties,
  client_info,
  GENERATE_UUID() AS document_id,
  * EXCEPT(additional_properties, client_info, document_id)
FROM `moz-fx-data-backfill-1.ads_backend_live.interaction_v1`
WHERE DATE(submission_timestamp) = '2026-03-17'

-- request_stats
INSERT INTO `moz-fx-data-backfill-1.ads_backend_stable.request_stats_v1`
SELECT
  additional_properties,
  client_info,
  GENERATE_UUID() AS document_id,
  * EXCEPT(additional_properties, client_info, document_id)
FROM `moz-fx-data-backfill-1.ads_backend_live.request_stats_v1`
WHERE DATE(submission_timestamp) = '2026-03-17'
```

## Insert into prod stable table

Requires DSRE assistance for production write access:

```
bq query \
  --nouse_legacy_sql \
  --destination_table 'moz-fx-data-shared-prod:ads_backend_stable.interaction_v1' \
  --append_table=true \
  'SELECT * FROM `moz-fx-data-backfill-1.ads_backend_stable.interaction_v1` WHERE DATE(submission_timestamp) = "2026-03-17"'

bq query \
  --nouse_legacy_sql \
  --destination_table 'moz-fx-data-shared-prod:ads_backend_stable.request_stats_v1' \
  --append_table=true \
  'SELECT * FROM `moz-fx-data-backfill-1.ads_backend_stable.request_stats_v1` WHERE DATE(submission_timestamp) = "2026-03-17"'
```

## Validate stable table

Verify production data looks correct after insertion:

```sql
SELECT
  COUNT(*) AS ping_count,
  DATE(submission_timestamp) AS submission_date,
  document_type
FROM `moz-fx-data-shared-prod.ads_backend_stable.<ping_type>_v1`
WHERE DATE(submission_timestamp) >= '2026-03-10'
GROUP BY ALL
ORDER BY submission_date
```

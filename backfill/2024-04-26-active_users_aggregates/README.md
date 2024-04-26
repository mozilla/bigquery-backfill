# Backfill active_users_aggregates for mobile apps from 2021-01-01
 
- Implements [DENG-3543](https://mozilla-hub.atlassian.net/browse/DENG-3543).
- This backfill is required after implementing [DENG-2989](https://mozilla-hub.atlassian.net/browse/DENG-2989).
- GCP project used:  `moz-fx-data-shared-prod`

## Context
The definition of active_bits, dau, wau, mau has been moved to the upstream views clients_last_seen for Desktop and
baseline_clients_last_seen for Mobile.
In parallel to the integration of this change, a backfill of active_user_aggregates is required from 2021.
This is becuase a direct backfill would affect the metrics due to shredder's impact, and that is avoided in this PR
by querying `unified metrics` (not impacted by shredder) to backfill in temporary tables in dataset `backfills_staging_derived`
tables `<app_name>_active_users_aggregates_v3_<backfill_date>`.
These tables will replace the aggregate tables in production after data is validated by Data Science.

- Step 1: Backfill `backfills_staging_derived.<app_name>_active_users_aggregates_v3_<backfill_date>` from 2021-01-01 using the corresponding `<app_name>_query.sql`
- Step 2: Validate (DS & DE) that both the table created in step 1 and the production table `<app_name>_derived.active_users_aggregates_v3` are an exact match.
- DE [validation query](https://console.cloud.google.com/bigquery?ws=!1m7!1m6!12m5!1m3!1smozdata!2sus-central1!3sb281e5ab-74f3-43c9-b26a-f6d8f4bcb42a!2e1) in BigQuery. Should run per app.
- Step 3: Copy the table created in step 1 to table <app_name>_derived.active_users_aggregates_v3, replacing the existing one.
- Step 4. Merge the changes to the query in [PR-5396](https://github.com/mozilla/bigquery-etl/pull/5396) to align with the aggregates schema. 
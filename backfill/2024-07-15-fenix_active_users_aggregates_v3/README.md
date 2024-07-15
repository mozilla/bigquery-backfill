# Backfill fenix_derived.active_users_aggregates_v3 from 2021-01-01
 
- Implements the fix described in [DENG-4310](https://mozilla-hub.atlassian.net/browse/DENG-4310).
- GCP project used:  `moz-fx-data-shared-prod`

## Context
The distribution of clients per app_name to calculate MAU & monthly_users is incorrect, see details in [incident doc](https://docs.google.com/document/d/1Maw_yJh7JPqZD2mw-Ub-ouZTrIq9nYQwbiKGH6GTfS4/edit?usp=sharing).

- Step 1: DE runs the backfill of data in `backfills_staging_derived` for the impacted period, using the baseline ping as source for `distribution_id` after 2024-01-01 and the metrics ping before that. The query [fenix_query_before_2024.sql](https://github.com/mozilla/bigquery-backfill/blob/DENG-4310_fix_fenix_backfill/backfill/2024-07-15-fenix_active_users_aggregates_v3/fenix_query_before_2024.sql) runs from 2021-01-01 until 2023-12-31. The query [fenix_query_after_2024.sql](https://github.com/mozilla/bigquery-backfill/blob/DENG-4310_fix_fenix_backfill/backfill/2024-07-15-fenix_active_users_aggregates_v3/fenix_query_after_2024.sql) runs from 2024-01-01 until CURRENT_DATE.
- Step 2: DE runs the [validation query](https://console.cloud.google.com/bigquery?ws=!1m7!1m6!12m5!1m3!1smozdata!2sus-central1!3s9ebf4e77-be0d-46de-b959-3a043353ceaf!2e1) which accounts for shredder impact and should **not** return any rows. Notify DS.
- Step 3. DS runs validations.
- Step 4. DE deploys data to production.

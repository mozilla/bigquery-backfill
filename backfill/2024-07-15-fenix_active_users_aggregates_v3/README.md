# Backfill fenix_derived.active_users_aggregates_v3 2021-01-01
 
- Implements the fix described in [DENG-34310](https://mozilla-hub.atlassian.net/browse/DENG-4310).
- GCP project used:  `moz-fx-data-shared-prod`

## Context
The distribution of clients per app_name to calculate MAU is incorrect and needs to be corrected. See details in [incident doc](https://docs.google.com/document/d/1Maw_yJh7JPqZD2mw-Ub-ouZTrIq9nYQwbiKGH6GTfS4/edit?usp=sharing).

- Step 1: DE runs the backfill of data in `backfills_staging_derived` for the impacted period, using the baseline ping as source for `distribution_id` after 2024-01-01 and the metrics ping before that.
- Step 2: DE runs the [validation query](https://console.cloud.google.com/bigquery?ws=!1m7!1m6!12m5!1m3!1smozdata!2sus-central1!3s9ebf4e77-be0d-46de-b959-3a043353ceaf!2e1) which accounts for shredder impact and should **not** return any rows. Notify DS.
- Step 3. DS runs validations.
- Step 4. DE deploys data to production.

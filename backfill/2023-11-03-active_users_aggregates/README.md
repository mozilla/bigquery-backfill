# Backfill active_users_aggregates for mobile apps from 2021-01-01
 
- [DENG-1833](https://mozilla-hub.atlassian.net/browse/DENG-1833): Update fenix_derived.active_users_aggregates with new DAU definition for mobile
- GCP project used:  `moz-fx-data-shared-prod.analysis`

## Context
The definition of DAU for mobile is updated to count only users who interact with the app by accunting for the duration of each session.
Integrating this new definition requires a full backfill of the active_users_aggregates tables. However, a direct backfill would affect
the metrics due to shredder's impact, which is avoided in this PR by querying `unified metrics` (not impacted by shredder) to backfill
in a temporary table `analysis.deng_1833_<app_name>_active_users_aggregates`.
After data is validated, the temporary table can be moved to the corresponding app dataset and the previous version of the table can be
deprecated.

- Step 1: Backfill `analysis.deng_1833_<app_name>_active_users_aggregates` from 2021-01-01 using the corresponding `<app_name>_query.sql`
- Step 2: Validate (DS & DE) that both the table created in step 1 and `<app_name>_derived.active_users_aggregates_v2` are an exact match.
  - DE Validation query (per-app) https://sql.telemetry.mozilla.org/queries/95789/source
- Step 3: Copy the table created in step 1 to <app_name>_derived.active_users_aggregates_v3
- Step 4: Follow the deprecation process and SRE support to deprecate `<app_name>_derived.active_users_aggregates_v2`

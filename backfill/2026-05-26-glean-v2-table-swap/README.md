# Glean V2 to V1 table swap

For https://mozilla-hub.atlassian.net/browse/DENG-10877

Follow up to the initial plan in
https://docs.google.com/document/d/1STMFrEpK6UPLKJGGojESJ_rniGAg3yf4RMo8H0RAeps/edit?tab=t.0

## Goal

Replace the existing v1 glean live and stable tables with the backfilled v2 tables that
carry the glean.2 schema, so the v1 table names keep working with the new schema which will have significantly fewer columns.
For each table we back up the current v1, drop it, and rename v2 to v1. This runs in stage first,
then prod, starting with the test set below before the full rollout. The v2 tables already
hold the validated backfill, so the swap is the remaining step to cut the pipeline over to
the new schema without renaming downstream references.

some choices:

1. Swap live tables first because copy_deduplicate can go from live v2 to stable v1 without issue
2. Sink loader, ingestion deploys, and bigquery deploys will be paused during live and stable table replacement causing a backlog for the loader
    * Alternative is to only pause these while replacing the live tables and restart them while replacing the stable tables which would result in a much smaller the backlog. But we aren’t able to deploy bigquery schemas when stable and live don’t match, meaning we would need to bypass the standard deployment flow to deploy the ingestion sink. While possible, this is more steps and complexity meaning more things that can go wrong.
    * I would estimate the table replacement to take <30 minutes, largely from `firefox_desktop_stable.metrics_v1`
3. v1 table replacement is done with a `DROP TABLE v1` and `ALTER TABLE v2 RENAME TO v1` which should prevent doubling up on storage costs for time travel bytes. The tradeoff compared to `CREATE OR REPLACE TABLE v1 COPY v2` is that it isn’t atomic and will cause some downtime where the table doesn’t exist
    * most tables can be dropped and renamed in <20 seconds
    * In testing, `firefox_desktop_stable.metrics_v1` takes ~10 minutes to rename so in that case, `CREATE OR REPLACE v1 COPY v2`
        * The table currently has 773 TB of physical storage which would be ~$7144 for 14 days of time travel + fail-safe
    * `org_mozilla_firefox_stable.metrics_v1` took ~2.5 minutes
    * `firefox_desktop_live.metrics_v1` took 15 seconds

Backfill is done and validated for org_mozilla_fennec_aurora and org_mozilla_fenix_nightly so these are some more informed steps with example queries.
These will first be run on the test set of tables:
```sql
org_mozilla_fenix_nightly_stable.metrics_v1
org_mozilla_fenix_nightly_stable.sync_v1
org_mozilla_fenix_nightly_stable.first_session_v1
org_mozilla_fenix_nightly_stable.adjust_attribution_v1
org_mozilla_fenix_nightly_stable.health_v1
org_mozilla_fenix_nightly_stable.captcha_detection_v1
org_mozilla_fennec_aurora_stable.metrics_v1
org_mozilla_fennec_aurora_stable.sync_v1
org_mozilla_fennec_aurora_stable.captcha_detection_v1
org_mozilla_fennec_aurora_stable.first_session_v1
org_mozilla_fennec_aurora_stable.health_v1
org_mozilla_fennec_aurora_stable.adjust_attribution_v1
```

## Setup steps to be completed in advance

1. ~~Update SQL generators to handle v1 tables with glean.2 schema [https://github.com/mozilla/bigquery-etl/pull/9233](https://github.com/mozilla/bigquery-etl/pull/9233)~~ **DONE**
2. Provision backfill project for v1 table backups
    - Grant editor access to one of the projects via https://github.com/mozilla-services/cloudops-infra/blob/master/projects/data-backfill/tf/prod/projects/backfill.tf
    - https://github.com/mozilla-services/cloudops-infra/pull/6954
3. Verify prod stable table row counts between v1 and v2 (will differ because shredder is only running on v2)
    * Script: [validate_row_counts.py](./validate_row_counts.py). Compares per-partition row counts and tolerates up to a 5% drop in v2 from shredder.
4. Create dataset per app for live/stable and prod/stage
```sql
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_stage`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_stable_prod`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_stage`;
CREATE SCHEMA `moz-fx-data-backfill-1.org_mozilla_fenix_nightly_live_prod`;
```
5. Copy v1 stable tables to backfill project
```sql
CREATE SNAPSHOT TABLE 
    `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_stage.metrics_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v1`;
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Setup step 5".

## Stage/non-prod

1. Add apps to v2_to_v1 allowlist in schema generator to update the schemas of the v1 tables [https://github.com/mozilla/mozilla-schema-generator/pull/315](https://github.com/mozilla/mozilla-schema-generator/pull/315)
2. Pause ingestion and BigQuery deploys for prod and stage
   - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/
   - bigquery-prod and bigquery-stage https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/
3. Stop structured loader sink for prod and stage: deploy https://github.com/mozilla/dataservices-infra/compare/benwu/stage-loader-zero, which sets `enabled: false` on the `structured-decoded-loader`
   - Announce in #data-platform-infra-wg that live table updates will be paused
   - Verify that there are no more loader pods active
4. Run the schema generator Airflow task and verify v1 schemas are updated and v2 schemas are deleted in generated-schemas
5. Copy v1 live tables to the backfill project
    * As far as I can tell, the load jobs don’t use a streaming buffer so it’s safe to copy when the loader is turned off
    * Using snapshots to make read-only copy and not pay twice for the time travel bytes of the prod table
    * firefox_desktop_live.metrics_v1 snapshot took ~14 seconds
```sql
CREATE SNAPSHOT TABLE 
    `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.metrics_v1`
CLONE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1`
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Stage step 5".
6. Drop v1 live tables and rename v2 tables (needs Cloud Eng)
```sql
DROP TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v2` RENAME TO metrics_v1;
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Stage step 6".
7. Copy current day live data from v1 live backup tables to v2 live prod tables.
    * This can run concurrently with stable table replacement.
    * Script: [copy_live_data.py](./copy_live_data.py) `--env stage`. Reads from the `_stage` live backups and appends today's partition to the renamed live tables. Pass `--dry-run` to preview.
8. Drop v1 stable tables and rename v2 tables (needs Cloud Eng), already backed up
```sql
DROP TABLE 
`moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v1`;
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_stable.metrics_v2` 
RENAME TO metrics_v1;
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Stage step 8".
9. Turn Jenkins deploys for stage back on (bigquery-stage and data-ingestion-sink-stage)
10. Verify sink is updated with new schemas: https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-stage/
    - And latest image is deployed https://dataservices.argocd.global.mozgcp.net/applications/ingestion-sink-stage-us-west1-ingestion-sink 
11. Turn structured loader back on by reverting the stage change: set `enabled: true` (or remove the override) on the `structured-decoded-loader` workload in `values-stage.yaml`.
12. Verify that pings correctly write to the new v1 live tables
    - TODO: construct test payloads to send to edge server

## Production

The production phase will happen after the final step of the stage phase (verifying that live pings write to the new tables). 

These steps mirror the stage steps but target `moz-fx-data-shared-prod` and the `_prod`
backfill datasets. Several stage steps already cover prod and aren't repeated here:
the schema generator allowlist change (stage step 1), the deploy pause for prod (stage step 2),
the prod structured loader stop (stage step 3, which sets `enabled: false` for prod and stage),
and the schema generator run (stage step 4, shared generated-schemas).

1. Copy v1 live tables to the backfill project
    * As far as I can tell, the load jobs don’t use a streaming buffer so it’s safe to copy when the loader is turned off
    * Using snapshots to make read-only copy and not pay twice for the time travel bytes of the prod table
```sql
CREATE SNAPSHOT TABLE 
    `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_prod.metrics_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v1`
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Prod, live backup".
2. Drop v1 live tables and rename v2 tables (needs Cloud Eng)
```sql
DROP TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_live.metrics_v2` RENAME TO metrics_v1;
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Prod, live drop/rename".
3. Copy current day live data from v1 live backup tables to v2 live prod tables.
    * This can run concurrently with stable table replacement.
    * Script: [copy_live_data.py](./copy_live_data.py) `--env prod`. Same script as stage step 7, reads from the `_prod` live backups. Pass `--dry-run` to preview.
4. Copy v1 stable tables to the backfill project (prod equivalent of setup step 5, into the `_prod` datasets)
```sql
CREATE SNAPSHOT TABLE 
    `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_stable_prod.metrics_v1`
CLONE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v1`;
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Prod, stable backup".
5. Drop v1 stable tables and rename v2 tables (needs Cloud Eng), already backed up
    * This is where it can take >10 minutes for firefox_desktop_stable.metrics_v1
```sql
DROP TABLE 
`moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v1`;
ALTER TABLE `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.metrics_v2` 
RENAME TO metrics_v1;
```
Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql) under "Prod, stable drop/rename".
6. Turn Jenkins deploys for prod back on
    - bigquery-prod and data-ingestion-sink-prod
7. Verify sink is updated with new schemas: [https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-prod/](https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-prod/)
    - And latest image is deployed https://dataservices.argocd.global.mozgcp.net/applications/ingestion-sink-prod-us-west1-ingestion-sink
8. Turn structured loader back on by reverting the prod change: set `enabled: true` (or remove the override) on the `structured-decoded-loader` workload in `values-prod.yaml`.
9. Verify that pings correctly write to the new v1 live tables
    - Pings from the backlog should have the old distribution written to additional_properties

## Cleanup

1. Remove tables from the allowlist in telemetry-airflow: [https://github.com/mozilla/telemetry-airflow/pull/2378](https://github.com/mozilla/telemetry-airflow/pull/2378)
2. Perform a test run of copy_deduplicate

## Backout steps

The exact action depends on when and why backout is done, so treat this as the
general order rather than a fixed script. Some things that could go wrong: sink
errors, copy_deduplicate fails afterwards, missing/incorrect rows in v2. Most of
this is the forward steps in reverse, using the snapshot backups taken before each
drop/rename. Run against the environment being backed out (`moz-fx-data-shar-nonprod-efed`
for stage, `moz-fx-data-shared-prod` for prod, with the matching `_stage`/`_prod`
backfill datasets).

1. Stop the structured loader sink again if it was already restarted: set `enabled: false`
   on the `structured-decoded-loader` workload in the relevant `values-*.yaml` (same as
   stage step 3). Confirm no loader pods are active.
2. Pause Jenkins deploys again if they were restarted (data-ingestion-sink and bigquery
   in data-shared), so the reverted schemas don't get redeployed mid-backout.
3. Revert the schema generator allowlist change ([mozilla-schema-generator#315](https://github.com/mozilla/mozilla-schema-generator/pull/315))
   and rerun the schema generator Airflow task so generated-schemas go back to v2 schemas
   and the v1 schemas are restored to the pre-swap state.
4. For each swapped table, undo the rename and restore the backup. The forward step dropped
   v1 and renamed v2 to v1, so the original v2 name no longer exists. Rename the current v1
   (the former v2) back to v2, then restore the v1 snapshot from the backfill project:
```sql
-- example for one live table in stage
ALTER TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1` RENAME TO metrics_v2;
CREATE TABLE `moz-fx-data-shar-nonprod-efed.org_mozilla_fennec_aurora_live.metrics_v1`
CLONE `moz-fx-data-backfill-1.org_mozilla_fennec_aurora_live_stage.metrics_v1`;
```
   Queries for the rest of the test tables are in [test_table_queries.sql](./test_table_queries.sql)
   under "Backout, stage" and "Backout, prod". Do this for both live and stable tables that were swapped.

5. Re-enable the structured loader (`enabled: true` / remove the override) and turn Jenkins
   deploys back on, so the sink picks the v2 schemas back up.

6. Copy any data that landed in v2 after the swap back into v1, mirroring the forward
   "copy current day live data" step but in the reverse direction.
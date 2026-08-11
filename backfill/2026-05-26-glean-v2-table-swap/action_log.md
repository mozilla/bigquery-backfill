## Action log

This is a chronological list of actions taken for the backfill. This is to make it reproducible
and note anything that diverged from the plan.

Times are in EDT

### 2026-08-05

setup
- ran [validate_row_counts.py](./validate_row_counts.py) to make sure v2 partitions were populated
  - results:
    ```text
    org_mozilla_fennec_aurora_stable.adjust_attribution: 0 mismatched partition(s)
    org_mozilla_fennec_aurora_stable.captcha_detection: 0 mismatched partition(s)
    org_mozilla_fennec_aurora_stable.first_session: 0 mismatched partition(s)
    org_mozilla_fennec_aurora_stable.health: 0 mismatched partition(s)
    org_mozilla_fennec_aurora_stable.metrics: 0 mismatched partition(s)
    org_mozilla_fennec_aurora_stable.sync: 0 mismatched partition(s)
    org_mozilla_fenix_nightly_stable.adjust_attribution: 0 mismatched partition(s)
    org_mozilla_fenix_nightly_stable.captcha_detection: 0 mismatched partition(s)
    org_mozilla_fenix_nightly_stable.first_session: 3 mismatched partition(s)
      20251120: v1=3, v2=2
      20260528: v1=3, v2=2
      20260611: v1=3, v2=2
    org_mozilla_fenix_nightly_stable.health: 0 mismatched partition(s)
    org_mozilla_fenix_nightly_stable.metrics: 0 mismatched partition(s)
    org_mozilla_fenix_nightly_stable.sync: 0 mismatched partition(s)
    ```
  - difference is from shredder and only noted because 3 -> 2 is a 33% drop

- created datasets for backup tables, job: `moz-fx-data-backfill-1:US.bquxjob_5590df4d_19fd388b0d0`
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

### 2026-08-06

- 3pm: I have write access to data-shared https://github.com/mozilla-services/cloudops-infra/pull/6962
- 3:02: backup stage stable tables `moz-fx-data-backfill-1:US.bquxjob_5d69eb5c_19fd87508e4`
- 3:35: backup prod stable tables `moz-fx-data-backfill-1:US.bquxjob_1cc1a71_19fd89271e8`
  - took four minutes with these small tables so this will take much longer for the rest of the tables
  - **make it more clear in the steps to do this for prod and stage in advance instead of while the sink is paused**
- 3:45: Mikael scales down prod and stage loaders
- 3:45: merged https://github.com/mozilla/mozilla-schema-generator/pull/315 to update schemas
- 3:47: disable jenkins deploys for:
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-stage/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-prod/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/job/bigquery-prod/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/job/bigquery-stage/
- 4:26: reverted everything because github actions is down
  - https://github.com/mozilla/mozilla-schema-generator/pull/323

### 2026-08-10

- 1pm: drop existing stable snapshots and recreate
  - stage: moz-fx-data-backfill-1:US.bquxjob_61496031_19fecac067d
  - prod: moz-fx-data-backfill-1:US.bquxjob_427ab2b6_19fecae0fa2
- 1:25: reverified row counts with [validate_row_counts.py](./validate_row_counts.py)
- 2:03: merge schema-generator change to update schemas https://github.com/mozilla/mozilla-schema-generator/pull/324
- 2:05: disable jenkins deploys for:
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-stage/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-prod/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/job/bigquery-stage/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/job/bigquery-prod/
- 2:07: scale down structured-decoded-loaders to 0:
  - stage: https://console.cloud.google.com/kubernetes/deployment/us-west1/dataservices-high-nonprod/ingestion-sink-stage/structured-decoded-loader/overview?project=moz-fx-dataservices-high-nonpr
  - prod: https://console.cloud.google.com/kubernetes/deployment/us-west1/dataservices-high-prod/ingestion-sink-prod/structured-decoded-loader/overview?project=moz-fx-dataservices-high-prod
  - **note**: [dataplatform/admins workgroup](https://protosaur.dev/dawg/workgroup/dataplatform#admins) can do this
    - Mikael showed me how to do this via k9s TUI, also possible through the GCP console
- 2:15: rerun the schema generator
  - verify generated-schemas
  - **note**: it can take 15+ minutes to run so probably don't need to scale down loaders yet to minimize downtime
  - **note**: schema gen doesn't really need to be finished yet, but I want to verify generated schemas are correct before doing everything else
- 2:20: Copy stage v1 live tables to backup
  - moz-fx-data-backfill-1:US.bquxjob_9b10108_19fece88297
  - **note**: doing this in parallel to schema generation while waiting on it
- 2:23: Copy prod v1 live tables to backup
  - moz-fx-data-backfill-1:US.bquxjob_620e0253_19fecea5dcc
  - moz-fx-data-backfill-1:US.bquxjob_41080064_19fececfc70
  - **note**: needed to run twice because I already had some backups created from an earlier test
  - **note**: these jobs took 15 seconds each
- 2:34: realized incompatibility allowlist is wrong https://github.com/mozilla/mozilla-schema-generator/pull/325
  - turned sink loaders back on
- 2:34: Also realized that play_store_attribution_v1 is missing
  - re-check tables:
    ```sql
    SELECT DISTINCT table_schema, table_name
    FROM `moz-fx-data-shared-prod.region-us.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS`
    WHERE table_schema IN ('org_mozilla_fenix_nightly_stable','org_mozilla_fennec_aurora_stable')
      AND REGEXP_CONTAINS(field_path, r'^metrics\.[^.]*_distribution$')
    ORDER BY table_schema, table_name
    ```
  - **note**: making the call here to just delete the existing play_store_attribution_v1 since they're empty, instead of creating v2 tables for them
- 3:10: rerun schema generator
- 3:17: drop live table backups
  - stage: moz-fx-data-backfill-1:US.bquxjob_69654e6a_19fed20282d
  - prod: moz-fx-data-backfill-1:US.bquxjob_3169db96_19fed1f862a
- 3:28: confirmed generated schemas updated
- 3:28: scale down loaders
  - stage: https://console.cloud.google.com/kubernetes/deployment/us-west1/dataservices-high-nonprod/ingestion-sink-stage/structured-decoded-loader/overview?project=moz-fx-dataservices-high-nonpr
  - prod: https://console.cloud.google.com/kubernetes/deployment/us-west1/dataservices-high-prod/ingestion-sink-prod/structured-decoded-loader/overview?project=moz-fx-dataservices-high-prod
- 3:30: backup live tables
  - stage: moz-fx-data-backfill-1:US.bquxjob_35c3ba9d_19fed27240b
  - prod: moz-fx-data-backfill-1:US.bquxjob_12c1f828_19fed282f87

#### stage

- 3:35: **Make sure backups exist** Drop prod v1 live tables
  - first table test: moz-fx-data-backfill-1:US.bquxjob_723f37fe_19fed2b612e
  - moz-fx-data-backfill-1:US.bquxjob_4c5041bb_19fed2c3837
- 3:40: Copy today's live data to stage v1 live tables via [copy_live_data.py](./copy_live_data.py) with `--env stage`
  - **dry run first**
  - **note**: this took 3 minutes for the metrics tables even though they only have a few rows due to query parsing/planning (the actual job stages started 3 minutes after the query started)
    Could be more problematic for larger tables later
- 3:52: **Make sure backups exist** Drop stage v1 stable tables and rename v2 tables
  - moz-fx-data-backfill-1:US.bquxjob_11443c4f_19fed3be31d
- 3:55: turn jenkins deploys for stage back on and wait for sink to update with new schemas
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-stage/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/job/bigquery-stage/
  - - **note**: Need to force deploy sink to update schemas (I think, need to verify)
- 3:55: scale structured loader back to 1 https://console.cloud.google.com/kubernetes/deployment/us-west1/dataservices-high-nonprod/ingestion-sink-stage/structured-decoded-loader/overview?project=moz-fx-dataservices-high-nonpr
- 3:55: submit test ping

#### Production

- 4:01: **Make sure backups exist** Drop prod v1 live tables
  - moz-fx-data-backfill-1:US.bquxjob_1b8588ad_19fed443d4a
- 4:03: Copy today's live data to prod v1 live tables via [copy_live_data.py](./copy_live_data.py) with `--env prod`
  - **note**: org_mozilla_fennec_aurora_live.metrics_v1 took 5 minutes
- 4:18: **Make sure backups exist** Drop prod v1 stable tables and rename v2 tables
  - moz-fx-data-backfill-1:US.bquxjob_6c9fba5e_19fed52dbb1
  - **note**: took 3 minutes
- 4:22: turn jenkins deploys for prod back on and wait for sink to update with new schemas
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-ingestion-sink/job/data-ingestion-sink-prod/
  - https://ops-master.jenkinsv2.prod.mozaws.net/job/gcp-pipelines/job/data-shared/job/bigquery-prod/
  - **note**: Need to force deploy sink to update schemas (I think, need to verify)
- 4:29: scale structured loader back to 3 https://console.cloud.google.com/kubernetes/deployment/us-west1/dataservices-high-prod/ingestion-sink-prod/structured-decoded-loader/overview?project=moz-fx-dataservices-high-prod
- 4:45: loader is working with no errors, still monitoring to make sure backlog goes down
- 4:50: oldest unacked message back to normal levels

#### clean up
- 4:50: realized I forgot to remove the apps from glean_v2_allowlist.yaml so the get redeployed by jenkins
  - https://github.com/mozilla/mozilla-schema-generator/blob/566ecf899329e41d9666e09db7e029912b51a99f/mozilla_schema_generator/configs/glean_v2_allowlist.yaml#L73
  - https://github.com/mozilla/mozilla-schema-generator/pull/326
- 5:24: remove the tables from shredder and copy_dedupe special cases https://github.com/mozilla/telemetry-airflow/pull/2378
  - also: https://github.com/mozilla/telemetry-airflow/pull/2410
- 6:15: run copy_deduplicate to test

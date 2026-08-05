## Action log

This is a chronological list of actions taken for the backfill. This is to make it reproducible
and note anything that diverged from the plan.

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
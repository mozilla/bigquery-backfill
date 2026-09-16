# Correct Glean server `events.timestamp` fields

There was a bug in the Glean server templates where `events.timestamp` fields were being set to Unix millisecond timestamp values instead of zero ([DENG-10432](https://mozilla-hub.atlassian.net/browse/DENG-10432)).
This affected four Glean server apps: `accounts_backend`, `relay_backend`, `subscription_platform_backend`, and `syncstorage_stable`.
The bug was fixed on 2026-02-09 ([glean_parser#831](https://github.com/mozilla/glean_parser/pull/831)), and the affected Glean server apps were all updated by 2026-05-13.

This backfill corrects the historical Glean server app events ping records that have non-zero `events.timestamp` values.

GCP project used: `moz-fx-data-backfill-1` ([cloudops-infra#7001](https://github.com/mozilla-services/cloudops-infra/pull/7001))

## Step 1: Check for affected Glean server events in production (completed 2026-09-11)

Run [`01_check_production_events.sh`](01_check_production_events.sh).

### Output

|                    table_id                    | affected_event_count |    min_timestamp    |    max_timestamp    |
|------------------------------------------------|---------------------:|---------------------|---------------------|
| accounts_backend_stable.events_v1              |         247683698209 | 2024-08-12 00:00:00 | 2026-05-13 20:28:36 |
| relay_backend_stable.events_v1                 |            155760457 | 2025-08-07 00:00:00 | 2026-03-17 15:27:12 |
| subscription_platform_backend_stable.events_v1 |               350410 | 2025-06-13 20:00:38 | 2026-05-13 20:20:00 |
| syncstorage_stable.events_v1                   |         125193033671 | 2025-08-07 00:00:00 | 2026-05-05 19:29:45 |

## Step 2: Clone affected tables to the backfill project (completed 2026-09-11)

Run [`02_clone_tables_to_backfill.sh`](02_clone_tables_to_backfill.sh).

## Step 3: Fix events ping records in the backfill project (completed 2026-09-12)

Run [`03_fix_events_in_backfill.py`](03_fix_events_in_backfill.py).

## Step 4: Confirm no affected Glean server events remain in the backfill project (completed 2026-09-13)

Run [`04_check_backfill_events.sh`](04_check_backfill_events.sh).

### Output

|                    table_id                    | affected_event_count | min_timestamp | max_timestamp |
|------------------------------------------------|---------------------:|---------------|---------------|
| accounts_backend_stable.events_v1              |                    0 |          NULL |          NULL |
| relay_backend_stable.events_v1                 |                    0 |          NULL |          NULL |
| subscription_platform_backend_stable.events_v1 |                    0 |          NULL |          NULL |
| syncstorage_stable.events_v1                   |                    0 |          NULL |          NULL |

## Step 5: Copy fixed partitions back to production (completed 2026-09-16)

Run [`05_copy_partitions_to_production.py`](05_copy_partitions_to_production.py).

**Note:** This won't copy the `relay_backend_stable.events_v1` partitions after all because that would resurrect rows recently deleted by shredder.

### Output

```
Copying 335 partitions from moz-fx-data-backfill-1:subscription_platform_backend_stable.events_v1 to moz-fx-data-shared-prod:subscription_platform_backend_stable.events_v1, between 2025-06-13 and 2026-05-13...
Copied 335 of 335 partitions from moz-fx-data-backfill-1:subscription_platform_backend_stable.events_v1 to moz-fx-data-shared-prod:subscription_platform_backend_stable.events_v1.

Copying 267 partitions from moz-fx-data-backfill-1:syncstorage_stable.events_v1 to moz-fx-data-shared-prod:syncstorage_stable.events_v1, between 2025-08-12 and 2026-05-05...
Copied 267 of 267 partitions from moz-fx-data-backfill-1:syncstorage_stable.events_v1 to moz-fx-data-shared-prod:syncstorage_stable.events_v1.

Copying 635 partitions from moz-fx-data-backfill-1:accounts_backend_stable.events_v1 to moz-fx-data-shared-prod:accounts_backend_stable.events_v1, between 2024-08-17 and 2026-05-13...
Copied 635 of 635 partitions from moz-fx-data-backfill-1:accounts_backend_stable.events_v1 to moz-fx-data-shared-prod:accounts_backend_stable.events_v1.
```

## Step 6: Fix `relay_backend_stable.events_v1` records directly in production (completed 2026-09-16)

Run [`06_fix_events_in_production.py`](06_fix_events_in_production.py).

### Output

```
Fixing moz-fx-data-shared-prod.relay_backend_stable.events_v1 partitions from 2025-08-12 to 2026-03-17...
Waiting on bqjob_r192aa55689e4bda5_000001a0ab3cf03d_1 ... (48s) Current status: DONE   
Number of affected rows: 152391648
```

## Step 7: Confirm no affected Glean server events remain in production (completed 2026-09-16)

Run [`07_recheck_production_events.sh`](07_recheck_production_events.sh).

### Output

|                    table_id                    | affected_event_count | min_timestamp | max_timestamp |
|------------------------------------------------|---------------------:|---------------|---------------|
| accounts_backend_stable.events_v1              |                    0 |          NULL |          NULL |
| relay_backend_stable.events_v1                 |                    0 |          NULL |          NULL |
| subscription_platform_backend_stable.events_v1 |                    0 |          NULL |          NULL |
| syncstorage_stable.events_v1                   |                    0 |          NULL |          NULL |

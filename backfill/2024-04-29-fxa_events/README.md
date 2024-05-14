# 2024-04-29 Backfill FxA events tables from accounts_events

See https://mozilla-hub.atlassian.net/browse/DENG-2407

## accounts_backend
Test backfill and validation is documented in [backend_test/README.md](backend_test/README.md).

We'll backfill accounts_backend_stable.events_v1 table from 2024-01-01 to 2024-04-17 (inclusive) since the `events` ping was enabled on 2024-04-17. We're backfilling from `accounts_events` table, so we need to convert custom pings-as-events to event metrics. This is done in [convert_backend.sql](convert_backend.sql).

Backfilling:
```bash
python backfill_accounts_backend_events_v1.py
```

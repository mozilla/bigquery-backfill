# 2024-04-29 Backfill FxA events tables from accounts_events

See https://mozilla-hub.atlassian.net/browse/DENG-2407

## accounts_backend
Backfill and validation is documented in [backend/README.md](backend_test/README.md).

We're backfilling accounts_backend_stable.events_v1 table from 2024-01-01 to 2024-04-17 (inclusive) since the `events` ping was enabled on 2024-04-17. We're backfilling from `accounts_events` table, so we need to convert custom pings-as-events to event metrics. This is done in [backend/convert_backend.sql](convert_backend.sql).

### Inserting data to production table
This runs 20 processes in parallel, finishing in under a minute.
```bash
seq 0 107 | xargs -I {} date -d "2024-01-01 {} days" +%Y%m%d | xargs -P20 -n1 -I {} bash -c 'bq cp --force mozdata:analysis.akomar_accounts_backend_events_v1\${} moz-fx-data-shared-prod:accounts_backend_stable.events_v1\${}'
```

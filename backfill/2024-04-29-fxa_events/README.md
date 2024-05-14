# 2024-04-29 Backfill FxA events tables from accounts_events

See https://mozilla-hub.atlassian.net/browse/DENG-2407

## accounts_backend
Backfill and validation is documented in [backend/README.md](backend_test/README.md).

We're backfilling accounts_backend_stable.events_v1 table from 2024-01-01 to 2024-04-17 (inclusive) since the `events` ping was enabled on 2024-04-17. We're backfilling from `accounts_events` table, so we need to convert custom pings-as-events to event metrics. This is done in [backend/convert_backend.sql](convert_backend.sql).

### Inserting data to production table
```sql
-- we need to delete incomplete data from the first day `events` pings was enabled
DELETE FROM `moz-fx-data-shared-prod.accounts_backend_stable.events_v1` WHERE date(submission_timestamp) = '2024-04-17';

-- backfill data from 2024-01-01 to 2024-04-17
INSERT INTO
  `moz-fx-data-shared-prod.accounts_backend_stable.events_v1`
SELECT
  *
FROM
  `mozdata.analysis.akomar_accounts_backend_events_v1`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-01' AND '2024-04-17';
```

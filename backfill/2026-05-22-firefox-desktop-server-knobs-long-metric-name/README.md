# 2026-05-22 Firefox Desktop Release `ping_info.server_knobs_config` schema errors (long metric name in rollout)

Bug for error: https://bugzilla.mozilla.org/show_bug.cgi?id=2042207

Bug for backfill: https://bugzilla.mozilla.org/show_bug.cgi?id=2042215

DSRE ticket for prod insert: TBD

## Summary

Starting 2026-05-19, Firefox Desktop Release on v151+ began producing schema validation errors of the form:

```
org.everit.json.schema.ValidationException:
  #/ping_info/server_knobs_config/metrics_enabled/custom_distribution.cert_validation_success_by_ca_2:
  string [custom_distribution.cert_validation_success_by_ca_2] does not match pattern
  ^[a-z_][a-z0-9_]{0,29}(\.[a-z_][a-z0-9_]{0,29})+$
```

The offending key was emitted because a Remote Settings rollout targeting Windows Release
included `custom_distribution.cert_validation_success_by_ca_2` in `metrics_enabled` — the
second `.`-separated segment (`cert_validation_success_by_ca_2`, 31 chars) exceeded the
schema's 30-char-per-segment limit. The error only began appearing on Release when Glean
SDK v67.2.0+ (which adds `ping_info.server_knobs_config`) reached Firefox Release for the
first time, with Firefox 151 on 2026-05-19.

Schema fix:
[mozilla-pipeline-schemas#871](https://github.com/mozilla-services/mozilla-pipeline-schemas/pull/871)
relaxed the validation for keys under `ping_info.server_knobs_config.metrics_enabled`:

- `maxLength`: 61 → 111
- `pattern`: `^[a-z_][a-z0-9_]{0,29}(\.[a-z_][a-z0-9_]{0,29})+$` → `^[a-z_][a-z0-9_.]+$`

Because the schema was loosened to accept the original payloads, **no decoder workaround
is needed for this backfill** — the rejected pings can be reingested as-is against a
schemas tarball that includes PR #871.

## Scope

Only the **`baseline`** ping is being backfilled.

`baseline` is the only ping that feeds `firefox_desktop.baseline_clients_daily`, which is
the source of truth for DAU/MAU in `active_users_aggregates_v3` and downstream KPI
forecasts. The other ~16 affected ping types
(`events`, `newtab`, `addons`, `health`, `use-counters`, `messaging-system`, etc.) have
analytical value but do not move the headline DAU number that motivates this backfill.
Restoring data for those types can be handled as a separable Phase 2 if individual
stakeholders are blocked.

## Affected pings

See [affected_pings.sql](./affected_pings.sql) for the per-day count of rejected baseline
pings during the incident window. The query runs against the aggregated error-counts
table `mozdata.monitoring.structured_detailed_error_counts` (the underlying
`payload_bytes_error.structured` is access-restricted because it contains raw payload
bytes; the aggregated table exposes the dimensions we need for scoping).

## Steps for backfill

1. Set up backfill project (permissions + copy errored rows)
2. Mirror prod schemas into the backfill project so column order matches prod
3. Reingest affected pings via the Decoder dataflow job → backfill staging tables
4. Validate and dedupe the staging tables
5. Insert into prod stable table (requires DSRE assistance)
6. Validate the prod stable table

## 1. Set up backfill project

Permissions are granted via a cloudops-infra PR (see precedent
[cloudops-infra#6055](https://github.com/mozilla-services/cloudops-infra/pull/6055) /
[#6194](https://github.com/mozilla-services/cloudops-infra/pull/6194)). The PR must grant
the `moz-fx-data-backfill-1` project:

- Read access to the relevant rows in `moz-fx-data-shared-prod.payload_bytes_error.structured`
  (filtered to the `document_namespace`/`document_type`/`error_type`/`error_message` we
  care about — see the WHERE clause in the next code block).
- Dataset-level write access on the **staging** datasets in the backfill project:
  `moz-fx-data-backfill-1.firefox_desktop_live` and
  `moz-fx-data-backfill-1.firefox_desktop_stable`. These are fresh datasets created by
  [mirror-prod-tables.sh](./mirror-prod-tables.sh); they are **not** the prod live/stable
  tables in `moz-fx-data-shared-prod`. No write access to prod is requested via this PR
  — the final append into `moz-fx-data-shared-prod.firefox_desktop_stable.baseline_v1`
  is performed in §5 by DSRE.

Once permissions are in place, copy the affected error rows into a backfill input table:

```sql
INSERT INTO `moz-fx-data-backfill-1.payload_bytes_error.backfill`
SELECT
  -- List all columns explicitly because column order may differ between source and target.
  -- Use `bq show --schema moz-fx-data-shared-prod:payload_bytes_error.structured` to get the
  -- column list (see 2025-01-22 backfill README for the exact column list — it changes
  -- rarely, so reuse if still current).
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE
  DATE(submission_timestamp) BETWEEN '2026-05-19' AND '2026-05-20'
  AND document_namespace = 'firefox-desktop'
  AND document_type      = 'baseline'
  AND error_type         = 'ParsePayload'
  AND error_message LIKE '%cert_validation_success_by_ca_2%'
```

## 2. Mirror prod schemas

The DSRE-auto-created tables in the backfill project can have a different column order
than prod (see 2024-11-06 backfill for the symptom). To avoid the need for explicit
column listing on the final insert, we pre-create the staging tables in the backfill
project by copying the schema directly from prod:

```
./mirror-prod-tables.sh
```

This creates `moz-fx-data-backfill-1.firefox_desktop_live.baseline_v1` and
`moz-fx-data-backfill-1.firefox_desktop_stable.baseline_v1` with prod's exact field
order, so a later `SELECT *` will work via name-based append.

## 3. Reingest via Decoder dataflow job

The dataflow job reads from `payload_bytes_error.backfill`, runs the rows through the
gcp-ingestion Decoder against a schemas tarball that includes PR #871, and writes valid
pings to `firefox_desktop_live.baseline_v1` and remaining errors to
`payload_bytes_error.structured` in the backfill project.

Run from the `ingestion-beam/` directory in a checkout of
[gcp-ingestion](https://github.com/mozilla/gcp-ingestion):

```
ingestion-beam % .../start_dataflow.sh
```

`--schemasLocation` in [start_dataflow.sh](./start_dataflow.sh) must be set to a
published schemas tarball that includes PR #871. The latest tarball path can be
discovered by listing `gs://moz-fx-data-prod-dataflow/schemas/`. Update the placeholder
in the script before running.

If you need to clear out output tables between runs:

```sql
TRUNCATE TABLE `moz-fx-data-backfill-1.firefox_desktop_live.baseline_v1`;
TRUNCATE TABLE `moz-fx-data-backfill-1.payload_bytes_error.structured`;
```

Useful note (from 2025-01-22): you may need
`gcloud auth application-default set-quota-project moz-fx-data-backfill-1` if you hit
quota-project errors.

## 4. Validate and dedupe

After the dataflow job completes, check the residual errors in the backfill project to
make sure no new failure modes appear:

```sql
SELECT COUNT(*), error_message
FROM `moz-fx-data-backfill-1.payload_bytes_error.structured`
WHERE submission_timestamp > '2026-05-18'
GROUP BY error_message
ORDER BY 1 DESC
```

We expect this to be very small — any rows here are pings that fail validation for
reasons unrelated to PR #871.

Dedupe by `document_id` within the backfill `_live` table and exclude `document_id`s
already present in the prod `_stable` table. See [dedupe.sql](./dedupe.sql). Run with:

```
bq query \
  --use_legacy_sql=false \
  --destination_table='moz-fx-data-backfill-1:firefox_desktop_stable.baseline_v1' \
  --replace=true \
  "$(cat dedupe.sql)"
```

We dedupe per day (not across the full backfill window), matching the semantics of the
`copy_deduplicate` job that maintains the live → stable promotion in production.

## 5. Insert into prod stable table

This step requires DSRE assistance (see TBD ticket above).

Because we mirrored the prod schema in step 2, column order in
`moz-fx-data-backfill-1.firefox_desktop_stable.baseline_v1` already matches prod. We can
therefore use a name-based append rather than an explicit column-by-column `INSERT`
statement:

```
./insert_to_prod.sh
```

This is equivalent to the 2025-01-22 final-insert approach (and avoids the
`insert_to_prod.py` / YAML schema machinery the 2024-11-06 backfill needed because of
column-order mismatch).

## 6. Validate prod stable

After insert, spot-check the prod stable table for the backfilled window:

```sql
-- Ping volume by date and app_display_version, restricted to v151+ release.
SELECT
  DATE(submission_timestamp) AS submission_date,
  client_info.app_display_version,
  COUNT(*) AS ping_count,
  COUNT(DISTINCT client_info.client_id) AS distinct_clients
FROM
  `moz-fx-data-shared-prod.firefox_desktop_stable.baseline_v1`
WHERE
  DATE(submission_timestamp) BETWEEN '2026-05-19' AND '2026-05-20'
  AND normalized_channel = 'release'
  AND normalized_os      = 'Windows'
  AND client_info.app_display_version LIKE '151.%'
GROUP BY ALL
ORDER BY submission_date, app_display_version
```

Compare against:

```sql
SELECT submission_date, COUNT(DISTINCT client_id) AS dau
FROM `mozdata.firefox_desktop.baseline_clients_daily`
WHERE submission_date BETWEEN '2026-05-19' AND '2026-05-20'
  AND normalized_channel  = 'release'
  AND normalized_os       = 'Windows'
  AND app_display_version LIKE '151.%'
GROUP BY submission_date
ORDER BY submission_date
```

Re-run after the downstream `baseline_clients_daily` ETL has been re-triggered (or
naturally rolled over) for the affected dates. DAU should increase by approximately the
number reported in the impact estimation (see incident report).

## Downstream re-run

`baseline_clients_daily` and `active_users_aggregates_v3` are derived tables. After the
prod stable insert lands, request a re-run of the affected partitions for the date range
of the backfill — coordinate with the team that owns the
`firefox_desktop_derived.*_v3` jobs. KPI forecast pipelines that consume
`active_users_aggregates_v3` will then pick up the corrected numbers on their next run.

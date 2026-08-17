# 2026-08-14 Drop records with leaked file paths from `third_party_modules` telemetry

Bug for leak/fix: https://bugzilla.mozilla.org/show_bug.cgi?id=2061342
(client fix commit `babf9c5b0122`)

Backfill bug / DSRE ticket: https://mozilla-hub.atlassian.net/browse/DENG-11464

## Summary

`WinUtils::PreparePathForTelemetry` should reduce every module path to a bare
filename or a path under one of four allowed prefixes (`%ProgramFiles%\`,
`%ProgramFiles% (x86)\`, `%SystemRoot%\`, `%TEMP%\`). A whitelist prefix-match bug
(fixed in `babf9c5b0122`) let some values keep a real directory tree. These full 
paths reached the `third_party_modules` ping and are sitting in the stable table:

- `payload.modules[].resolved_dll_name`
- `payload.processes[].value.events[].requested_dll_name` (`processes` is a map)

Analysis query: https://sql.telemetry.mozilla.org/queries/124609?p_channel=all&p_days_back=90

## Approach

- Table: `moz-fx-data-shared-prod.telemetry_stable.third_party_modules_v4`
- **Stable — drop affected records.** For each affected partition, stage a copy
  with the affected rows filtered out and overwrite the prod partition with it.
- **Live — leave as-is.** `telemetry_live.third_party_modules_v4` ages out on its
  ~30-day expiry, so leaks there disappear on their own (see caveat in step 6).
- **Window: the last 180 days = the stable table's full retained history.**
  `third_party_modules_v4` has a 180-day retention, so anything older has already
  expired.


## Steps

**1. Set up backfill project.** A cloudops-infra PR adds a `module "bug_11464"` entry
in `projects/data-backfill/tf/prod/projects/backfill.tf` (precedent:
[cloudops-infra#6055](https://github.com/mozilla-services/cloudops-infra/pull/6055)).
Needs only: read on the prod table, and dataset-level write on the staging dataset
`moz-fx-data-backfill-2.telemetry_stable`. No prod write (that's step 6, via DSRE).

**2. Mirror prod schema.** `./mirror-prod-table.sh` creates the staging table with
prod's exact schema so `bq cp -f` works in step 6. **Confirm the partitioning /
clustering flags against `bq show` on prod** before running.

**3. Scope + build `affected_dates.txt`.**
[`01_scope_by_date.sql`](./01_scope_by_date.sql) returns, per submission_date, the
count of affected records (= rows that will drop).

```
bq query --use_legacy_sql=false --format=csv < 01_scope_by_date.sql | tail -n +2 | cut -d, -f1 | sort -u > affected_dates.txt
```

**4. Stage cleaned partitions.** `./run_drop.sh affected_dates.txt` runs
[`02_drop_affected.sql`](./02_drop_affected.sql) per partition — `SELECT *` with
affected rows filtered out (`NOT EXISTS` a leak). Parallelizable (`PARALLELISM`,
default 8).

**5. Validate.** [`03_validate.sql`](./03_validate.sql) checks per partition that
zero affected rows remain and exactly the affected rows were dropped
(`staging_rows == prod_rows - prod_affected_rows`). **Zero rows returned = pass**;
do not proceed otherwise.

```
bq query --use_legacy_sql=false --format=pretty < 03_validate.sql
```

**6. Overwrite prod (DSRE).** `./copy_to_prod.sh` `bq cp -f`s each cleaned partition
over prod — the only step that writes to `moz-fx-data-shared-prod`. The script reads
the partition list straight from the staging table (which contains only the affected
partitions), so DSRE runs a single self-contained command with no dates file to pass.

*copy_deduplicate caveat:* for the **trailing ~30 days** where live data still
exists, a *re-run* of `copy_deduplicate` would re-promote uncleaned live data over
a cleaned partition. Either process that window last and don't re-run
`copy_deduplicate` for those dates, or re-run the drop for that window once live has
expired (>30 days after the fixed build ships).

**7. Confirm + clean up.** Re-run `01_scope_by_date.sql` against prod (expect no
rows), then `bq rm -r -f moz-fx-data-backfill-2:telemetry_stable`.

## Going forward

The client fix ships in new builds, but unfixed builds keep emitting leaked paths,
so this backfill only cleans history up to the run date. The pipeline-side stop-gap
is [gcp-ingestion#2964](https://github.com/mozilla/gcp-ingestion/pull/2964), which
drops affected `third_party_modules` pings at ingest **without** recording them to
the error tables (so the leaked paths never land in `payload_bytes_error` either).
Once that is deployed, no new affected rows arrive and this backfill does not need
re-running.

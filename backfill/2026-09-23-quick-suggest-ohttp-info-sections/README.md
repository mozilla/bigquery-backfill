# Suggest pings: OHTTP move, info sections removed, error reingest + geo/isp scrub

For https://bugzilla.mozilla.org/show_bug.cgi?id=2074273

Companion to https://github.com/mozilla/gcp-ingestion/pull/2980, which strips
`client_info` and `ping_info` before schema validation so pings from clients that have
not yet updated keep being accepted.

## Placeholders

Two values need substituting before anything here runs:

| placeholder | what it is |
| --- | --- |
| `BACKFILL_PROJECT` | project holding the staging datasets and the copied error rows |
| `gs://BACKFILL_STAGING_BUCKET` | GCS bucket for the schemas tarball, GeoIP databases and Dataflow temp |

## Summary

The suggest pings moved to OHTTP submission with `metadata.include_info_sections: false`.
Two pieces of cleanup follow.

1. **Reingest.** Between the scrubber deploy and the schema deploy, the deployed schema
   and the payloads clients were sending disagreed, so pings were rejected to
   `payload_bytes_error`. Cutover window **2026-09-22 to 2026-09-23**.
2. **Scrub.** Historical rows carry IP derived `metadata.geo` and `metadata.isp` that the
   ping no longer collects. Covers **all history**, not just the cutover window.

## Scope

15 stable tables. Live tables are out of scope for the scrub: continuously written, so DML
fights the streaming buffer, and partitions age out within days.

| namespace | doctypes |
| --- | --- |
| firefox-desktop | quick-suggest, urlbar-keyword-exposure |
| org-mozilla-{firefox, firefox-beta, fenix, fenix-nightly, fennec-aurora} | fx-suggest, fx-suggest-api |
| org-mozilla-ios-{firefox, firefoxbeta, fennec} | fx-suggest |

Fields nulled: `metadata.geo.{city, country, db_version, subdivision1, subdivision2}` and
`metadata.isp.{db_version, name, organization}`.

Four tables are empty and can be skipped: both `fenix_nightly` and both `fennec_aurora`.
Backups taken on 2026-09-22, before the schema deploy.

## Steps

```
bq mk -d --location=US BACKFILL_PROJECT:backfill_input
bq mk -d --location=US BACKFILL_PROJECT:staging_live
```

| # | file | what |
| --- | --- | --- |
| 1 | [01_affected_pings.sql](./01_affected_pings.sql) | scope the window, confirm counts fall away outside it |
| 2 | [02_copy_error_rows.sql](./02_copy_error_rows.sql) | copy rejected pings into the backfill project |
| 3 | [03_mirror_staging_tables.sql](./03_mirror_staging_tables.sql) | staging + decoder error tables, mirroring prod |
| 4 | [start_dataflow.sh](./start_dataflow.sh) | Decoder replay, build must include PR #2980 |
| 5 | [04_validate_reingest.sql](./04_validate_reingest.sql) | **gate.** Everything after this writes to prod |
| 6 | [05_dedupe.sql](./05_dedupe.sql) | per day, excluding ids already in prod |
| 7 | [06_load_to_prod.sql](./06_load_to_prod.sql) | 09-22 to stable, 09-23 to live |
| 8 | — | wait for `copy_deduplicate` to promote 09-23 |
| 9 | [07_scope.sql](./07_scope.sql) | scrub bounds and pre check |
| 10 | [08_scrub_geo_isp.sql](./08_scrub_geo_isp.sql) | the scrub |
| 11 | [09_cleanup.sql](./09_cleanup.sql) | remove raw payloads, staging, backups |

Step 7 routes by date because `copy_deduplicate`'s lookback has already passed 09-22, so
that date would never be promoted from live. Step 10 must not start before step 8, or the
verification passes and is invalidated hours later.


## Verification

Single end state check after both parts.

1. `07_scope.sql` statement 2 over the full range: `rows_dirty` zero everywhere. A zero
   result over a narrower range does not certify the scrub.
2. `rows_total` up by roughly the recovered volume from `01_affected_pings.sql`.
3. No `document_id` duplication against what was already in prod.

## Downstream

Two DAGs cover all eight affected derived tables. Reruns happen after both parts land.

| DAG | tables | owners |
| --- | --- | --- |
| `bqetl_search_terms_daily` | `suggest_impression_sanitized_v3`, `fct_suggest_impressions_daily_v1`, `suggest_partial_aggregates_daily_v1`, `adm_daily_aggregates_v1`, `adm_daily_dma_aggregates_v1` | najiang, cbeck, llisi |
| `bqetl_ctxsvc_derived` | `event_aggregates_v1`, `event_aggregates_suggest_v1`, `request_payload_suggest_v2` | rburwei, skahmann |


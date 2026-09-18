# 2026-09-18 Scrub Java exception messages from Android crash pings

Issue description: https://bugzilla.mozilla.org/show_bug.cgi?id=2073234

Ingestion-side filtering: https://github.com/mozilla/gcp-ingestion/pull/2979

Bug for this work: https://bugzilla.mozilla.org/show_bug.cgi?id=2073281

## Approach

In-place `UPDATE` DML instead of stage-and-copy because this is easy to express as DML.
A partition rewrite would require reconstructing the `metrics` struct.

19 tables in scope. Nine app namespaces: the `fenix`, `focus_android` and
`klar_android` groupings, `_stable` and `_live`, plus
`telemetry_derived.firefox_crashes_v1`:

```
org_mozilla_firefox        org_mozilla_focus
org_mozilla_firefox_beta   org_mozilla_focus_beta
org_mozilla_fenix          org_mozilla_focus_nightly
org_mozilla_fenix_nightly  org_mozilla_klar
org_mozilla_fennec_aurora
```

`org_mozilla_reference_browser` is excluded because it has no recent pings.

Live tables are included instead of left to expire.

Derived table is scoped by `normalized_app_id`. The query hardcodes
`CAST(NULL AS STRING)` for its two desktop branches and passes the real value
through for the Android ones, so naming the nine app ids keeps desktop untouched.

## Steps

2024-08-01 to 2026-09-18 is hardcoded in these queries.

Steps 2 and 4 require write access to the live and stable tables, and payload_bytes_error.

**1. Scope.** [`01_scope_by_date.sql`](./01_scope_by_date.sql) returns affected
row counts per table per submission_date. This file doubles as the post-scrub check.

**2. Scrub.** [`02_scrub.sql`](./02_scrub.sql). 19 `UPDATE` statements plus the shared UDFs

**3. Scope the error stream.**
[`03_scope_error_rows.sql`](03_scope_error_rows.sql). Pings that failed
ingestion land in `payload_bytes_error.structured` as gzipped raw payloads, which
`02_scrub.sql` does not touch.

**4. Delete affected error rows.**
[`04_delete_error_rows.sql`](04_delete_error_rows.sql). Identify, review,
delete. There is no SQL path from scrubbed JSON back to a gzipped payload, so
deletion rather than scrubbing; the rows are diagnostic and few.

## Measurements

| Scope                                             | Figure                                            |
|---------------------------------------------------|---------------------------------------------------|
| `org_mozilla_firefox_stable` 2026-09-15           | 58,763 rows, 23,280 affected                      |
| `telemetry_derived.firefox_crashes_v1` 2026-09-15 | 61,602 Android rows, 24,455 affected              |
| Derived table overall                             | 775 partitions, 2024-08-03 - 2026-09-16, 6.21 TiB |
| Error stream                                      | 46 affected rows over 28 dates, 3 namespaces      |

Error-stream detail: 44 confirmed structurally, plus 2 whose payload is not valid
JSON but contains `crash.java_exception` as text. Affected namespaces are
`org-mozilla-firefox` (44), `org-mozilla-firefox-beta` (1), `org-mozilla-fenix`
(1). No payload in the entire retention window contains a `JavaException`
annotation, so `meta_annotations` is not implicated in the error stream at all.

## Validation performed

Two prod copies were scrubbed and checked against their sources with
`03_validate_test_copy.sql`. Both came back clean on every column:

- `telemetry_derived.firefox_crashes_v1`, 3 partitions, 5,246,919 rows
- `org_mozilla_firefox_stable.crash_v1`, 3 partitions, 173,812 rows

Both copies also matched prod on row count per partition, had no rows added or
missing, left no field nulled or materialized, and had zero rows still matching
the detection predicate afterwards.

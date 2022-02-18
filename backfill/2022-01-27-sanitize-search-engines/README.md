# Sanitize search engine values in historical data

Investigation log for https://bugzilla.mozilla.org/show_bug.cgi?id=1751979

It must match the pipeline sanitization logic in [MessageScrubber](https://github.com/mozilla/gcp-ingestion/blob/main/ingestion-beam/src/main/java/com/mozilla/telemetry/decoder/MessageScrubber.java),
particularly the `processForBug1751955` and `processForBug1751753` methods there.

## Status

As of 2022-02-16.

`main_v4` has now been fully sanitized via Shredder.

`main_summary_v4` is currently being sanitized via Shredder.

All mobile stable tables have been sanitized; whd ran the following on 2022-02-18:

```bash
bq cp -f moz-fx-data-backfill-20:org_mozilla_fenix_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_fenix_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_firefox_beta_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_firefox_beta_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_fenix_nightly_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_fenix_nightly_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_fennec_aurora_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_fennec_aurora_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_focus_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_focus_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_focus_beta_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_focus_beta_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_focus_nightly_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_focus_nightly_stable.metrics_v1
bq cp -f moz-fx-data-backfill-20:org_mozilla_klar_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_klar_stable.metrics_v1
# This one is ~100 TB, but will still probably only take a minute or two
bq cp -f moz-fx-data-backfill-20:org_mozilla_firefox_stable.metrics_v1 moz-fx-data-shared-prod:org_mozilla_firefox_stable.metrics_v1
```

Various backfills continue to be staged into backfill-20.


## Plan for running backfill

Basic plan:

- Prep query for desktop backfill, get thorough review on the logic
- Evaluate how we might incorporate this backfill logic into Shredder
- Get `main_v4` sanitization running, as this will likely take a full month to process
- Do a full rerun of `clients_daily` and all downstream ETL after `main_v4` has processed

Mobile:

- The datasets are much smaller, so it may be feasible to run the queries more manually
  rather than hooking into the shredder machinery

## What actually happened

After much testing, we found a configuration where we can run a `SELECT` statement
with destination set to a partition of the table. In that query, we can both drop
rows with `client_id` for which we've received a deletion request AND do the field
rewrites. We incorporated that logic into Shredder and let it run.

What follows is a long stream of consciousness of the different approaches we
tried and the issues we found along the way.

## Backfill derived desktop tables

We set up a GCE instance in the `moz-fx-data-backfill-20` project using an Ubuntu image
that includes `bq` and `tmux`. We start a `tmux` session so that commands continue
to run if we get disconnected.

The instance does not have a public IP and can't communicate with the outside world.
So we scp the bigquery-etl tarball to the instance and untar.

### clients_daily

```
CREATE TABLE
  telemetry_derived.clients_daily_v6 
  LIKE `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6
```

Modify query to be able to run in an arbitrary project:

```
cat sql/moz-fx-data-shared-prod/telemetry_derived/clients_daily_v6/query.sql | sed -e 's/telemetry_stable/moz-fx-data-shared-prod.telemetry_stable/g' -e 's/udf\./mozdata.udf./g' -e 's/udf_js/mozdata.udf_js/g' > cd.sql
```

Try running on reserved slots:

```
seq 0 1 | xargs -I@ date -d '2022-02-13 - @ day' +%F | xargs -P5 -n1 bash -c 'set -ex; echo Processing $1;  bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-slots --parameter submission_date:DATE:$1 --destination_table=moz-fx-data-backfill-20:telemetry_derived.clients_daily_v6\$${1//-} < cd.sql' -s
```

Processed 12 partitions overnight. 2022-02-13 back through 2022-02-02.

Started on shared-prod, parallelism 5 at 7:40 AM. Starting from 2022-02-01:
```
seq 12 400 | xargs -I@ date -d '2022-02-13 - @ day' +%F | xargs -P5 -n1 bash -c 'set -ex; echo Processing $1;  bq query --nouse_legacy_sql --project_id=moz-fx-data-shared-prod --parameter submission_date:DATE:$1 --destination_table=moz-fx-data-backfill-20:telemetry_derived.clients_daily_v6\$${1//-} < cd.sql' -s
```

We processed ~150 partitions in 8 hours at parallelism of 5 in a single project.

Then increased parallelism to 10:

```
seq 0 648 | xargs -I@ date -d '2021-08-31 - @ day' +%F | xargs -P10 -n1 bash -c 'set -ex; echo Processing $1;  bq query --nouse_legacy_sql --project_id=moz-fx-data-shared-prod --parameter submission_date:DATE:$1 --destination_table=moz-fx-data-backfill-20:telemetry_derived.clients_daily_v6\$${1//-} < cd.sql' -s
```

We processed ~200 partitions in 12 hours at parallelism 10, so no real change in speed. This is limited by contention for on-demand slots within a single project.

### clients_last_seen

```
CREATE TABLE
  `moz-fx-data-backfill-20.telemetry_derived.clients_last_seen_v1`
  LIKE `moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v1`
```

Populate a first partition:

```
bq cp moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v1'$20210904' moz-fx-data-backfill-20:telemetry_derived.clients_last_seen_v1'$20210904'
```

```
cat sql/moz-fx-data-shared-prod/telemetry_derived/clients_last_seen_v1/query.sql | sed -e 's/clients_daily_v6/moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6/g' -e 's/clients_last_seen_v1/moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v1/g' -e 's/clients_first_seen_v1/moz-fx-data-shared-prod.telemetry_derived.clients_first_seen_v1/g' -e 's/udf\./mozdata.udf./g' -e 's/udf_js/mozdata.udf_js/g' > cls.sql
```

We start `clients_last_seen`:
```
seq 0 166 | xargs -I@ date -d '2021-09-01 + @ day' +%F | xargs -P1 -n1 bash -c 'set -ex; echo Processing $1;  bq query --nouse_legacy_sql --project_id=moz-fx-data-shared-prod --parameter submission_date:DATE:$1 --destination_table=moz-fx-data-backfill-20:telemetry_derived.clients_last_seen_v1\$${1//-} < cls.sql' -s
```

Next round of `clients_last_seen`:
```
```

## Backfill mobile tables

### Mobile stable tables

Make datasets:

```
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_firefox_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_fenix_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_firefox_beta_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_fenix_nightly_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_fennec_aurora_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_focus_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_focus_beta_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_focus_nightly_stable
bq mk --project_id moz-fx-data-backfill-20 org_mozilla_klar_stable
```

Most of these are small enough to rewrite in a single query:

```
cat org_mozilla_fenix.sql | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_firefox_beta/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_fenix_nightly/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_fennec_aurora/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_focus/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_focus_beta/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_focus_nightly/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
cat org_mozilla_fenix.sql | sed "s/org_mozilla_fenix/org_mozilla_klar/g" | bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-20
```

These were all run successfully on 2022-02-17.

For Fenix release, we run an incremental query. First, create the table:

```
CREATE TABLE
  `moz-fx-data-backfill-20.org_mozilla_firefox_stable.metrics_v1`
LIKE 
  `moz-fx-data-shared-prod.org_mozilla_firefox_stable.metrics_v1`
```

And then run incremental queries distributed over the backfill projects:

```
seq 0 0 | xargs -I@ date -d '2020-01-20 + @ day' +%F | xargs -P10 -n1 bash -c 'set -ex; echo Processing $1; bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-2${1: -1} --parameter submission_date:DATE:$1 --destination_table=moz-fx-data-backfill-20:org_mozilla_firefox_stable.metrics_v1\$${1//-} < org_mozilla_firefox_incremental.sql' -s
```

Validate:

```
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_firefox/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_fenix/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_firefox_beta/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_fenix_nightly/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_fennec_aurora/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_focus/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_focus_beta/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_focus_nightly/g' | bq query --nouse_legacy_sql
cat compare_metrics_prod.sql | sed 's/org_mozilla_firefox/org_mozilla_klar/g' | bq query --nouse_legacy_sql
```

### Mobile derived tables

We should only need to reprocess `mobile_search_clients_daily_v1`, `mobile_search_clients_last_seen_v1`,
and `mobile_search_aggregates_v1`.

## Query approaches for sanitizing main_v4

Doing a query populate via `SELECT` is appearing to be untenable, as Shredder is
seeing jobs time out at 6 hours when running over a full partition. `DELETE` statements
have been more effective.

We could try to do a `MERGE` statement which can handle both deletes and updates.
I created some small sample tables, and the following appears to work:

```
MERGE mozdata.analysis.klukas_merge_src1 AS src
USING mozdata.analysis.klukas_merge_deletion AS d
ON src.client_id = d.client_id
WHEN MATCHED AND DATE(submission_timestamp) = '2022-01-10' THEN
  DELETE
WHEN NOT MATCHED BY SOURCE AND DATE(submission_timestamp) = '2022-01-10' THEN
  UPDATE SET payload.keyed_histograms.search_counts = [STRUCT("hi" AS key, "there" AS value)]
```

I used a constant for the value in the `UPDATE` because I was otherwise receiving an error
about correlated subqueries not being allowed in `UPDATE` statements.

The following is allowed:

```
MERGE ...
  UPDATE SET payload.keyed_histograms.search_counts = payload.keyed_histograms.search_counts
```

But we get the `Correlated Subquery is unsupported in UPDATE clause` error if we change
the target value to involve a minimal UNNEST subquery:

```
MERGE ...
  UPDATE SET payload.keyed_histograms.search_counts =
    ARRAY(SELECT AS STRUCT * FROM UNNEST(payload.keyed_histograms.search_counts))
```

This [lack of subquery support is documented](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-manipulation-language#limitations):

> Correlated subqueries within a when_clause, search_condition, merge_update_clause or merge_insert_clause are not supported for MERGE statements.

And indeed a standalone `UPDATE` outside of a `MERGE` statement _does_ allow a subquery:

```
CREATE TEMP FUNCTION sanitize_search_counts(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^.]+\\.in-content[:.][^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY(SELECT AS STRUCT
    IF(REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*") IS NULL OR REGEXP_EXTRACT(key, "[^.]+\\.in-content[:.][^:]+:(.*)") IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*"), "other.scrubbed")) AS key,
      value
  FROM base)
));

UPDATE mozdata.analysis.klukas_merge_src1 
SET payload.keyed_histograms.search_counts = sanitize_search_counts(payload.keyed_histograms.search_counts)
WHERE DATE(submission_timestamp) = '2022-01-10'
```

Although if we add a few more fields to the `UPDATE` we hit "query too complex" errors:

```

CREATE TEMP FUNCTION sanitize_search_counts(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^.]+\\.in-content[:.][^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      value))
  FROM base
));

CREATE TEMP FUNCTION sanitize_scalar(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^:]+:[^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^:]+:[^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      value))
  FROM base
));

 UPDATE `mozdata.analysis.klukas_merge_src2`
 SET
payload.keyed_histograms.search_counts = sanitize_search_counts(payload.keyed_histograms.search_counts),
payload.processes.parent.keyed_scalars.browser_search_content_urlbar = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar),
payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff),
payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode),
payload.processes.parent.keyed_scalars.browser_search_content_searchbar = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_searchbar),
payload.processes.parent.keyed_scalars.browser_search_content_about_home = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_home),
payload.processes.parent.keyed_scalars.browser_search_content_about_newtab = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_newtab),
payload.processes.parent.keyed_scalars.browser_search_content_contextmenu = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_contextmenu),
payload.processes.parent.keyed_scalars.browser_search_content_webextension = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_webextension),
payload.processes.parent.keyed_scalars.browser_search_content_system = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_system),
payload.processes.parent.keyed_scalars.browser_search_content_tabhistory = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_tabhistory),
payload.processes.parent.keyed_scalars.browser_search_content_reload = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_reload),
payload.processes.parent.keyed_scalars.browser_search_content_unknown = sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_unknown)
 WHERE
  DATE(submission_timestamp) = "2022-01-10"
```

One possible way forward to allow a `MERGE` is a Javascript UDF, which does appear to be allowed:

```
CREATE TEMP FUNCTION sanitize_search_counts_js(x ARRAY<STRUCT<key STRING, value STRING>>)
RETURNS ARRAY<STRUCT<key STRING, value STRING>>
LANGUAGE js AS r"""
if (x === null) {
    return x;
}
const retval = x.map(x => {
  return {key: x.key + "-jstest", value: x.value};
});
return retval;
""";

MERGE mozdata.analysis.klukas_merge_src1 AS src
USING mozdata.analysis.klukas_merge_deletion AS d
ON src.client_id = d.client_id
WHEN MATCHED AND DATE(submission_timestamp) = '2022-01-10' THEN
  DELETE
WHEN NOT MATCHED BY SOURCE AND DATE(submission_timestamp) = '2022-01-10' THEN
  UPDATE SET payload.keyed_histograms.search_counts = 
    sanitize_search_counts_js(payload.keyed_histograms.search_counts)
```

I expect this will not be tenable at scale, but it's worth a performance test before we rule it out.

### Performance test for MERGE with JS UDF

Create an empty table like `main_v4`:

```
create or replace table mozdata.analysis.klukas_merge_src2
like `moz-fx-data-shared-prod.telemetry_stable.main_v4`
```

Copy in a single partition:

```
bq cp 'moz-fx-data-shared-prod:telemetry_stable.main_v4$20220110' 'mozdata:analysis.klukas_merge_src2$20220110'
```

Run the merge statement over the full partition:

```
CREATE TEMP FUNCTION sanitize_search_counts_js(x ARRAY<STRUCT<key STRING, value STRING>>)
RETURNS ARRAY<STRUCT<key STRING, value STRING>>
LANGUAGE js AS r"""
if (x === null) {
    return x;
}
const retval = x.map(x => {
  return {key: x.key + "-jstest", value: x.value};
});
return retval;
""";

MERGE mozdata.analysis.klukas_merge_src2 AS src
USING mozdata.analysis.klukas_merge_deletion AS d
ON src.client_id = d.client_id
WHEN MATCHED AND DATE(submission_timestamp) = '2022-01-10' THEN
  DELETE
WHEN NOT MATCHED BY SOURCE AND DATE(submission_timestamp) = '2022-01-10' THEN
  UPDATE SET payload.keyed_histograms.search_counts =
    sanitize_search_counts_js(payload.keyed_histograms.search_counts)

```

Which... worked! It ran in `1 hr 7 min`, processing 15.3 TB.

Here's an attempt to extend this to handle all the affected fields (still without real JS logic yet):

```
CREATE TEMP FUNCTION sanitize_search_content_js(x ARRAY<STRUCT<key STRING, value INT64>>)
RETURNS ARRAY<STRUCT<key STRING, value INT64>>
LANGUAGE js AS r"""
if (x === null) {
    return x;
}
const retval = x.map(x => {
  return {key: x.key + "-jstest", value: x.value - 1000};
});
return retval;
""";

CREATE TEMP FUNCTION sanitize_search_counts_js(x ARRAY<STRUCT<key STRING, value STRING>>)
RETURNS ARRAY<STRUCT<key STRING, value STRING>>
LANGUAGE js AS r"""
if (x === null) {
    return x;
}
const retval = x.map(x => {
  return {key: x.key + "-jstest", value: "modified: " + x.value};
});
return retval;
""";


MERGE mozdata.analysis.klukas_merge_src2 AS src
USING mozdata.analysis.klukas_merge_deletion AS d
ON src.client_id = d.client_id
WHEN MATCHED AND DATE(submission_timestamp) = '2022-01-10' THEN
  DELETE
WHEN NOT MATCHED BY SOURCE AND DATE(submission_timestamp) = '2022-01-10' THEN
  UPDATE SET
    payload.keyed_histograms.search_counts =
      sanitize_search_counts_js(payload.keyed_histograms.search_counts),
    payload.processes.parent.keyed_scalars.browser_search_content_urlbar = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_urlbar),
    payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff),
    payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode),
    payload.processes.parent.keyed_scalars.browser_search_content_searchbar = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_searchbar),
    payload.processes.parent.keyed_scalars.browser_search_content_about_home = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_about_home),
    payload.processes.parent.keyed_scalars.browser_search_content_about_newtab = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_about_newtab),
    payload.processes.parent.keyed_scalars.browser_search_content_contextmenu = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_contextmenu),
    payload.processes.parent.keyed_scalars.browser_search_content_webextension = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_webextension),
    payload.processes.parent.keyed_scalars.browser_search_content_system = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_system),
    payload.processes.parent.keyed_scalars.browser_search_content_tabhistory = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_tabhistory),
    payload.processes.parent.keyed_scalars.browser_search_content_reload = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_reload),
    payload.processes.parent.keyed_scalars.browser_search_content_unknown = sanitize_search_content_js(payload.processes.parent.keyed_scalars.browser_search_content_unknown)
```

This fails with `Resources exceeded during query execution: Not enough resources for query planning - too many subqueries`.
The most we can include is `search_counts` along with two of the keyed scalars before hitting this.

### Merging with a pre-computed sanitization source

To avoid query complexity, I wanted to see if I could push computation into the target table we're merging
from. So, instead of merging with a source of just deletion requests, we prepare a table with one row per
row in the stable table, but only the fields we're going to be updating.

Then, the merge doesn't have to do any computation, it just does the join and selects the precomputed
fields from the merge target table.

First, we prep a single partition for the target table with deletion request status
and sanitized fields pre-computed:

```
CREATE TEMP FUNCTION sanitize_search_counts(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^.]+\\.in-content[:.][^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      --key AS old_key,
      value))
  FROM base
));

CREATE TEMP FUNCTION sanitize_scalar(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^:]+:[^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^:]+:[^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      --key AS old_key,
      value))
  FROM base
));


create table mozdata.analysis.klukas_sanisrc1
AS
WITH
unioned AS (
 SELECT
  *
 FROM
  `moz-fx-data-shared-prod.telemetry_stable.main_v4`
  --`moz-fx-data-shared-prod.telemetry.main_1pct`
 WHERE
  --submission_timestamp BETWEEN "2022-01-10 12:00:00 UTC" AND "2022-01-10 12:10:00 UTC"
  DATE(submission_timestamp) = "2022-01-10"
),
base AS (
 SELECT
 submission_timestamp,
 document_id,
 client_id,
 sanitize_search_counts(payload.keyed_histograms.search_counts) AS search_counts,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar) AS browser_search_content_urlbar,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff) AS browser_search_content_urlbar_handoff,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode) AS browser_search_content_urlbar_searchmode,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_searchbar) AS browser_search_content_searchbar,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_home) AS browser_search_content_about_home,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_newtab) AS browser_search_content_about_newtab,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_contextmenu) AS browser_search_content_contextmenu,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_webextension) AS browser_search_content_webextension,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_system) AS browser_search_content_system,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_tabhistory) AS browser_search_content_tabhistory,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_reload) AS browser_search_content_reload,
sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_unknown) AS browser_search_content_unknown,
FROM
  unioned
--WHERE normalized_channel = 'nightly'
),
deletion_requests AS (
    SELECT
  DISTINCT client_id
FROM
  `moz-fx-data-shared-prod.telemetry_stable.deletion_request_v4`
  WHERE DATE(submission_timestamp) >= '2021-10-01'
)
SELECT base.*, 
  deletion_requests.client_id IS NOT NULL AS should_delete 
FROM base
LEFT JOIN deletion_requests USING (client_id)
```

Then, we try running the MERGE:

```
MERGE mozdata.analysis.klukas_merge_src2 AS src
USING (SELECT * FROM `mozdata.analysis.klukas_sanisrc1` WHERE DATE(submission_timestamp) = '2022-01-10') AS d
ON src.client_id = d.client_id
WHEN MATCHED AND should_delete AND DATE(src.submission_timestamp) = '2022-01-10' THEN
  DELETE
WHEN MATCHED AND NOT should_delete AND DATE(src.submission_timestamp) = '2022-01-10' THEN
  UPDATE SET
    payload.keyed_histograms.search_counts = d.search_counts,
    payload.processes.parent.keyed_scalars.browser_search_content_urlbar = d.browser_search_content_urlbar,
    payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff = d.browser_search_content_urlbar_handoff,
    payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode = d.browser_search_content_urlbar_searchmode,
    payload.processes.parent.keyed_scalars.browser_search_content_searchbar = d.browser_search_content_searchbar,
    payload.processes.parent.keyed_scalars.browser_search_content_about_home = d.browser_search_content_about_home,
    payload.processes.parent.keyed_scalars.browser_search_content_about_newtab = d.browser_search_content_about_newtab,
    payload.processes.parent.keyed_scalars.browser_search_content_contextmenu = d.browser_search_content_contextmenu,
    payload.processes.parent.keyed_scalars.browser_search_content_webextension = d.browser_search_content_webextension,
    payload.processes.parent.keyed_scalars.browser_search_content_system = d.browser_search_content_system,
    payload.processes.parent.keyed_scalars.browser_search_content_tabhistory = d.browser_search_content_tabhistory,
    payload.processes.parent.keyed_scalars.browser_search_content_reload = d.browser_search_content_reload,
    payload.processes.parent.keyed_scalars.browser_search_content_unknown = d.browser_search_content_unknown
```

Unfortunately, this still give the same error `Resources exceeded during query execution: Not enough resources for query planning - too many fields accessed or query is too complex.`.
So I'm guessing now that giving paths to nested fields in an UPDATE still means that under the hood,
this is getting unrolled to something that is accessing the nested fields through subqueries.

### Overwriting partitions via SELECT

The following ran successfully:

```
CREATE TEMP FUNCTION sanitize_search_counts(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^.]+\\.in-content[:.][^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      value))
  FROM base
));

CREATE TEMP FUNCTION sanitize_scalar(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^:]+:[^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^:]+:[^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      value))
  FROM base
));

create or replace table mozdata.analysis.klukas_query_populate_1
LIKE `moz-fx-data-shared-prod.telemetry_stable.main_v4`
 AS
SELECT *  REPLACE (
    --payload.keyed_histograms.search_counts = d.search_counts,
    (SELECT AS STRUCT payload.* REPLACE ((SELECT AS STRUCT payload.processes.* REPLACE (
      (SELECT AS STRUCT payload.processes.parent.* REPLACE(
        (SELECT AS STRUCT payload.processes.parent.keyed_scalars.* REPLACE(
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar) AS browser_search_content_urlbar,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff) AS browser_search_content_urlbar_handoff,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode) AS browser_search_content_urlbar_searchmode,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_searchbar) AS browser_search_content_searchbar,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_home) AS browser_search_content_about_home,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_newtab) AS browser_search_content_about_newtab,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_contextmenu) AS browser_search_content_contextmenu,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_webextension) AS browser_search_content_webextension,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_system) AS browser_search_content_system,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_tabhistory) AS browser_search_content_tabhistory,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_reload) AS browser_search_content_reload,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_unknown) AS browser_search_content_unknown
        )) AS keyed_scalars
      )) AS parent
    )) AS processes)) AS payload)
FROM `moz-fx-data-shared-prod.telemetry_stable.main_v4`
WHERE DATE(submission_timestamp) = '2022-01-10'
```

The job ID was `moz-fx-data-shared-prod:US.bquxjob_76d31125_17eda758969` and it completed in 33 min,
scanning 15.3 TB, consuming 71 days of slot time, and shuffling 58 TB.
Relud suggests that previous investigations using query-populate that timed out were
limited by the sorting necessary for writing a clustered result. This case is also using
a clustered destination table, but the `Sort+` stage appears to be taking only minimal resources,
so perhaps it's able to process the data without changing sort order?

I extended this to include the final field and also do deletions:
```
create or replace table mozdata.analysis.klukas_query_populate_2
LIKE `moz-fx-data-shared-prod.telemetry_stable.main_v4`
 AS
 WITH deletion_requests AS (
    SELECT
  DISTINCT client_id
FROM
  `moz-fx-data-shared-prod.telemetry_stable.deletion_request_v4`
  WHERE DATE(submission_timestamp) >= '2021-10-01'
)
SELECT main.* REPLACE (
    (SELECT AS STRUCT payload.* REPLACE (
     (SELECT AS STRUCT payload.keyed_histograms.* REPLACE (
       sanitize_search_counts(payload.keyed_histograms.search_counts) AS search_counts)) AS keyed_histograms,
     (SELECT AS STRUCT payload.processes.* REPLACE (
      (SELECT AS STRUCT payload.processes.parent.* REPLACE(
        (SELECT AS STRUCT payload.processes.parent.keyed_scalars.* REPLACE(
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar) AS browser_search_content_urlbar,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff) AS browser_search_content_urlbar_handoff,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode) AS browser_search_content_urlbar_searchmode,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_searchbar) AS browser_search_content_searchbar,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_home) AS browser_search_content_about_home,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_newtab) AS browser_search_content_about_newtab,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_contextmenu) AS browser_search_content_contextmenu,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_webextension) AS browser_search_content_webextension,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_system) AS browser_search_content_system,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_tabhistory) AS browser_search_content_tabhistory,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_reload) AS browser_search_content_reload,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_unknown) AS browser_search_content_unknown
        )) AS keyed_scalars
      )) AS parent
    )) AS processes)) AS payload)
FROM `moz-fx-data-shared-prod.telemetry_stable.main_v4` AS main
LEFT JOIN deletion_requests USING (client_id)
WHERE DATE(submission_timestamp) = '2022-01-10'
AND deletion_requests.client_id IS NULL
```

This took 48 minutes to complete, consumed 68 days of slot time, and shuffled 79 TB. Somewhat
more expensive, but still much better than the current performance we're seeing from Shredder.


#### Side Quest: Understand performance of previous Shredder experiments

Here is one of the queries that timed out at 6 hours in relud's experiments:

```
SELECT
  *
FROM
  `moz-fx-data-shared-prod.telemetry_stable.main_v4`
WHERE
  (
    client_id IN (
      SELECT
        client_id
      FROM
        `moz-fx-data-shared-prod.telemetry_stable.deletion_request_v4`
      WHERE
        DATE(submission_timestamp) >= '2021-09-20'
        AND DATE(submission_timestamp) < '2022-01-10'
    )
  ) IS NOT TRUE
  AND CAST(submission_timestamp AS DATE) = '2021-11-22'
```

Job ID is `moz-fx-data-shredder:US.fe6c1df7-103d-4170-b1cf-1b82eb18a468`, so note that it is
running in the `moz-fx-data-shredder` project. Also note that it's using `client_id IN` with
a subquery rather than using a join. I don't know whether that's handled differently
for performance or not. The problematic stage in the execution plan is `S0A: Join+` with detail
`LEFT OUTER HASH JOIN EACH WITH EACH ON $11 = $11520`. It shows max compute at 2095092290 ms and
is the only step not marked as complete in the plan.

Here is a DELETE that completed successfully in 2 hours:

```
DELETE
  `moz-fx-data-shared-prod.telemetry_stable.main_v4`
WHERE
  (
    client_id IN (
      SELECT
        client_id
      FROM
        `moz-fx-data-shared-prod.telemetry_stable.deletion_request_v4`
      WHERE
        DATE(submission_timestamp) >= '2021-09-20'
        AND DATE(submission_timestamp) < '2022-01-10'
    )
  )
  AND CAST(submission_timestamp AS DATE) = '2021-03-02'
```

The job ID is `moz-fx-data-shredder:US.dc5057c1-1127-4485-8fd2-8c34d74817b4` and the
execution plan shows 8 stages, the most expensive of which appear to be `Sort+` and
`Repartition`.

I'm left with more questions: 

- Is the `IN` construction more expensive than a join?
- Is there some sort of contention or metadata overhead involved when making changes
  directly to `main_v4` vs. populating a separate table for tests with identical structure?
- Is there something different in configuration for the `shredder` project compared to `shared-prod`?

I'm issuing some more test queries to probe these ideas.

It does appear that `IN` might be a bottleneck compared to `LEFT JOIN`. I ran the
following in `shared-prod`:

```
create or replace table mozdata.analysis.klukas_query_populate_3
LIKE `moz-fx-data-shared-prod.telemetry_stable.main_v4`
 AS
SELECT main.* REPLACE (
    (SELECT AS STRUCT payload.* REPLACE (
     (SELECT AS STRUCT payload.keyed_histograms.* REPLACE (
       sanitize_search_counts(payload.keyed_histograms.search_counts) AS search_counts)) AS keyed_histograms,
     (SELECT AS STRUCT payload.processes.* REPLACE (
      (SELECT AS STRUCT payload.processes.parent.* REPLACE(
        (SELECT AS STRUCT payload.processes.parent.keyed_scalars.* REPLACE(
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar) AS browser_search_content_urlbar,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff) AS browser_search_content_urlbar_handoff,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode) AS browser_search_content_urlbar_searchmode,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_searchbar) AS browser_search_content_searchbar,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_home) AS browser_search_content_about_home,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_about_newtab) AS browser_search_content_about_newtab,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_contextmenu) AS browser_search_content_contextmenu,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_webextension) AS browser_search_content_webextension,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_system) AS browser_search_content_system,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_tabhistory) AS browser_search_content_tabhistory,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_reload) AS browser_search_content_reload,
    sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_unknown) AS browser_search_content_unknown
        )) AS keyed_scalars
      )) AS parent
    )) AS processes)) AS payload)
FROM `moz-fx-data-shared-prod.telemetry_stable.main_v4` AS main
WHERE DATE(submission_timestamp) = '2022-01-10'
AND client_id NOT IN (
    SELECT
      DISTINCT client_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.deletion_request_v4`
    WHERE DATE(submission_timestamp) >= '2021-10-01'
)
```

Job ID `moz-fx-data-shared-prod:US.bquxjob_26a03a84_17edafced63` ran for 89 minutes,
took 179 days of slot time and shuffled 124 TB.
But this should be logically equivalent to the earlier query that took 48 minutes. This execution
plan goes up to `S1D` whereas the `LEFT JOIN` version goes up to only `S14`
so there may indeed be more data movement involved here.

On another tack, I tried the LEFT JOIN query in the `shredder` project. It ran for 1 hour, then I got:

> Resources exceeded during query execution: Your project or organization exceeded the maximum disk and memory limit available for shuffle operations. Consider provisioning more slots, reducing query concurrency, or using more efficient logic in this job.

I wouldn't be surprised if we've increased these limits for shared-prod.

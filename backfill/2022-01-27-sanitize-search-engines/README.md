# Sanitize search engine values in historical data

Implementation for https://bugzilla.mozilla.org/show_bug.cgi?id=1751979

It must match the pipeline sanitization logic in [MessageScrubber](https://github.com/mozilla/gcp-ingestion/blob/main/ingestion-beam/src/main/java/com/mozilla/telemetry/decoder/MessageScrubber.java),
particularly the `processForBug1751955` and `processForBug1751753` methods there.


## Plan for running backfill

EVOLVING plan

- Prep query for desktop backfill, get thorough review on the logic
- Evaluate how we might incorporate this backfill logic into Shredder
- Get `main_v4` sanitization running, as this will likely take a full month to process
- Do a full rerun of `clients_daily` and all downstream ETL after `main_v4` has processed

Mobile:

- The datasets are much smaller, so it may be feasible to run the queries more manually
  rather than hooking into the shredder machinery


## Query approaches

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
This may be consistent with recent findings by relud about performance improvement by copying
partitions out to a separate table, modifying, and then using a `COPY` operation to move the
data back into place in the source table.
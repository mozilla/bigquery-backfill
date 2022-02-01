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

One possible way forward to allow a `MERGE` is a Javascript UDF, which does appear to be allowed:

```
CREATE TEMP FUNCTION sanitize_search_counts_js(x ARRAY<STRUCT<key STRING, value STRING>>)
RETURNS ARRAY<STRUCT<key STRING, value STRING>>
LANGUAGE js AS r"""
  x
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

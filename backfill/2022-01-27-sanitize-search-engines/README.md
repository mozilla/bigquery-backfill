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
about correlated subqueries not being allowed in `UPDATE` statements, which I believe has
to do with the UDF logic. It's probably possible to unroll that a bit.

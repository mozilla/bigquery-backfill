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

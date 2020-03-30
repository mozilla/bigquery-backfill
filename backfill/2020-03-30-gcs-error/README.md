# Backfill GCS error records to BQ stable tables

See [bug 1625560](https://bugzilla.mozilla.org/show_bug.cgi?id=1625560) for more context.

This backfills the structured ingestion tables from 2020-02-18 through
2020-03-14. Telemetry is backfilled from 2020-02-19 through 2020-03-12.

## Action items

* Generate listing of telemetry and structured errors
* Appropriate `moz-fx-data-backfill-30` for backfill
* Copy data into `gs://bug-1625560-backfill` via `copy-data.sh`
* Create mirrored tables via `mirror-prod-tables.sh`
* Run dataflow jobs for backfill into stable-like tables via
  `launch-dataflow-job.sh`

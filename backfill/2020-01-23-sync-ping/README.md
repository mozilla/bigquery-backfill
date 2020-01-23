# Backfilling sync pings due to unexpected devices fields

See https://bugzilla.mozilla.org/show_bug.cgi?id=1610907

## Steps

We ran the backfill in the `moz-fx-data-backfill-4` project. 

First, we determine the backfill range by querying the relevant error table:

```
SELECT
  date(submission_timestamp) as dt, count(*)
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) >= "2020-01-10"
  AND document_type = 'sync'
  AND error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/devices/%: extraneous key % is not permitted'
  group by 1 order by 1
```

That showed the affected range as `2020-01-20` through `2020-01-23`.

Next, we create destination tables via the `mirror-prod-tables` script and
we populate the `backfill_input` table via query:

```
SELECT
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) BETWEEN "2020-01-20" AND "2020-01-23"
  AND document_type = 'sync'
  AND error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/devices/%: extraneous key % is not permitted'
```

Next, we construct a suitable Dataflow job configuration in
`launch-dataflow-sync-ping` and run the script.

We visit the GCP console, choose the `moz-fx-data-backfill-4` project
and go to the Dataflow section to watch the progress of the job.
It took about X minutes to run to completion.

We validate the results by checking counts per day:

```
WITH
SELECT
  DATE(submission_timestamp),
  COUNT(*)
FROM
  `moz-fx-data-backfill-4.telemetry.sync_v*`
GROUP BY
  1
ORDER BY
  1
```

Now, we append this data to the production live table
(requires ops-level permissions) and rerun copy_deduplicate
for the `sync_v*` tables at the command line, then check if
there's any downstream ETL we need to rerun via Airflow.

```
bq cp --append_table \
   moz-fx-data-backfill-4:telemetry_stable.sync_v4 \
   moz-fx-data-shared-prod:telemetry_stable.sync_v4
```

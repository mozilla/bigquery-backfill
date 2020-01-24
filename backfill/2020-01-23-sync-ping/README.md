# Backfilling sync pings due to unexpected devices fields

See https://bugzilla.mozilla.org/show_bug.cgi?id=1610907

## Steps

We ran the backfill in the `moz-fx-data-backfill-4` project. 

First, we determine the backfill range by querying the relevant error table:

```sql
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

```sql
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

It may be useful to do a quick run with a subset of data in order to make
sure the scripts are all properly configured by writing a subset of the backfill
input to a table and then running the script on the subset.  An important thing to 
remember to do is to delete the data written in the test; clean up can be done
by rerunning the `mirror-prod-tables` script.

```sql
SELECT
  *
FROM
  `moz-fx-data-backfill-4.payload_bytes_error.backfill_input`
LIMIT
  1000
```

We visit the GCP console, choose the `moz-fx-data-backfill-4` project
and go to the Dataflow section to watch the progress of the job.
It took about 42 minutes to run to completion.

We validate the results by checking counts per day:

```sql
SELECT
  DATE(submission_timestamp),
  COUNT(*)
FROM
  `moz-fx-data-backfill-4.telemetry_live.sync_v*`
GROUP BY
  1
ORDER BY
  1
```

There are no results in the `sync_v5` table so we can just look at `sync_v4`.

Now, we append this data to the production live table
(requires ops-level permissions):

```
bq cp --append_table \
   moz-fx-data-backfill-4:telemetry_live.sync_v4 \
   moz-fx-data-shared-prod:telemetry_live.sync_v4
```
 
We can then run copy_deduplicate (in the bigquery repo)
for the `sync_v4` table from the command line, then check if
there's any downstream ETL we need to rerun via Airflow.

```
./script/copy_deduplicate --project-id moz-fx-data-shared-prod \
    --dates 2020-01-20 2020-01-21 2020-01-22 2020-01-23 \
    --only telemetry_live.sync_v4
```

In this case, there is no downstream ETL depending on the sync pings.
Now both the prod live and stable tables are backfilled, so we can delete
the rows in the error table corresponding to the backfilled pings:

```sql
DELETE
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) BETWEEN '2020-01-20' AND '2020-01-23'
  AND document_type = 'sync'
  AND error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/devices/%: extraneous key % is not permitted'
```

We also need to update the error table with any errors that occurred during
the backfill (requires ops-level permissions):

```
bq cp --append_table \
  moz-fx-data-backfill-4:payload_bytes_error.telemetry \
  moz-fx-data-shared-prod:payload_bytes_error.telemetry
```

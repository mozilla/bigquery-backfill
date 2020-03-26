# Backfill from `payload_bytes_decoded` to stable tables

We had to kill a BQ live sink job on 2020-03-17 due to it getting into a bad
state. See https://bugzilla.mozilla.org/show_bug.cgi?id=1622977 for details.
Some portion of records (~20 GB of compressed JSON data) did not get loaded
to live tables in the telemetry namespace.

We choose the backfill-17 project for doing this work to match the date (17th).

## Stage target payloads into a table

First, we create placeholder datasets and tables in the target project:

```
./mirror-prod-tables
```

Next, we stage a source table following the pbd structure and we run a
query to populate it:

```
# Create the dataset that will hold the backfill source data
bq mk moz-fx-data-backfill-17:payload_bytes_decoded

# Copy a small pbd table (we choose core_v1) to the backfill project;
# we're going to overwrite the data, all we care about is getting the right structure.
bq cp moz-fx-data-shared-prod:payload_bytes_decoded.telemetry_telemetry__core_v1 moz-fx-data-backfill-17:payload_bytes_decoded.telemetry_all

# Now we run our query to populate the table.
bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-17 --destination_table moz-fx-data-backfill-17:payload_bytes_decoded.telemetry_all --replace -n 0 < query.sql
```

The query handles deduplication, so we'll be able to copy the results directly
into place in the historical ping tables (`_stable` tables). The query took
about 30 minutes to complete and scanned about 5 TB of compressed data.

## Run a Dataflow job to populate temporary stable tables

Running the Dataflow job requires credentials to be available in the environment.
One method of doing so is running:

```
gcloud auth application-default login
```

Or you can provision a service account in the backfill project, store the JSON blob locally,
and set `GOOGLE_APPLICATION_CREDENTIALS` to point at it.

Also, if you run maven within a docker container, you'll need to take care to pass
credentials to the container; you'll need to mount in the JSON file to a location
that the GCP SDKs will pick it up.

We launch the Dataflow job:

```
cd gcp-ingestion/ingestion-beam
/path/to/bigquery-backfill/backfill/2020-03-19-replay-payload-bytes-decoded/launch-dataflow-job
```

It took 2.5 hours to complete. The first ~20 minutes was waiting on data to
export to GCS, then it scaled up to 1000 workers for about 1 hour and scaled
back down to 1 worker waiting for BQ load jobs to complete.

## Validate results

Let's count distinct document IDs in live vs. stable vs. backfilled tables:

```
WITH
  pbd AS (
  SELECT
    _TABLE_SUFFIX AS tbl,
    COUNT(distinct document_id) AS n_pbd
  FROM
    `moz-fx-data-shared-prod.payload_bytes_decoded.telemetry_telemetry__*`
  WHERE
    DATE(submission_timestamp) = DATE "2020-03-17"
  GROUP BY
    1 ),
  live AS (
  SELECT
    _TABLE_SUFFIX AS tbl,
    COUNT(distinct document_id) AS n_live
  FROM
    `moz-fx-data-shared-prod.telemetry_live.*`
  WHERE
    DATE(submission_timestamp) = DATE "2020-03-17"
  GROUP BY
    1 ),
  stable AS (
  SELECT
    _TABLE_SUFFIX AS tbl,
    COUNT(distinct document_id) AS n_stable
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.*`
  WHERE
    DATE(submission_timestamp) = DATE "2020-03-17"
  GROUP BY
    1 ),
  bkf AS (
  SELECT
    _TABLE_SUFFIX AS tbl,
    COUNT(*) AS n_backfill,
    COUNT(distinct document_id) AS n_backfill_distinct
  FROM
    `moz-fx-data-backfill-17.telemetry_stable.*`
  WHERE
    DATE(submission_timestamp) = DATE "2020-03-17"
    and _TABLE_SUFFIX not like 'beam_load%'
  GROUP BY
    1 )
SELECT
  *, 
  (n_backfill) / n_live AS ratio,
  CASE
    WHEN n_backfill_distinct != n_backfill THEN 'BACKFILL IS NOT PROPERLY DEDUPED!'
    WHEN n_backfill < n_live THEN 'BACKFILL HAS FEWER RECORDS THAN LIVE!'
    WHEN n_backfill < n_stable THEN 'BACKFILL HAS FEWER RECORDS THAN STABLE!'
    WHEN n_pbd != n_backfill THEN 'BACKFILL DOES NOT MATCH PAYLOAD_BYTES_DECODED!'
  END AS checks
FROM
  pbd
FULL JOIN
  live
USING
  (tbl)
FULL JOIN
  stable
USING
  (tbl)
FULL JOIN
  bkf
USING
  (tbl)
order by ratio
```

The checks nearly all pass, meaning we're properly deduped and that we have strictly
more distinct documents in the backfill compared to live and stable tables.
There are 3 fewer `main_v4` pings in the backfill compared to `payload_bytes_decoded`
and 1 fewer `modules_v4` ping; I don't have an explanation for this, but it's such
a small effect as to be noise.

But yikes: looks like nearly 10% of main pings didn't make it into the live tables
due to this incident, which is significantly more severe than we originally
estimated. For other doc types, it looks like we missed an average of 3% of pings.

## Finalize

We iterate through all tables and issue a `bq cp` command to overwrite the
target partitions in prod stable tables. The following requires elevated
privileges; currently, you need to ask :klukas or ops to run this:

```bash
for table in $(bq ls -n 1000 --project_id moz-fx-data-backfill-17 telemetry_stable | grep TABLE | awk '{print $1}'); do
  bq cp -f moz-fx-data-backfill-17:telemetry_stable.${table}\$20200317 moz-fx-data-shared-prod:telemetry_stable.${table}\$20200317
done
```

If you run the above query again, you should see that `n_stable` and `n_backfill`
now match exactly.

## Cleanup

```
# BE CAREFUL! This removes all BQ datasets and GCS buckets from the target project,
# including their contents; it cannot be undone.
bq ls --project_id=moz-fx-data-backfill-17 | tail -n+3 | awk '{print $1}' | xargs -I{} -n1 bq rm -r -f "moz-fx-data-backfill-17:{}"
gsutil ls -p moz-fx-data-backfill-17 | xargs echo gsutil -m rm -r
```

And we're done!

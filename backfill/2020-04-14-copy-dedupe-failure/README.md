# Backfill from `payload_bytes_decoded` to stable tables

See https://bugzilla.mozilla.org/show_bug.cgi?id=1630336

The `copy_deduplicate` query for main pings failed due to having too many
duplicates; we instead handle deduping on top of payload_bytes_decoded
here and use Dataflow to get the data into the stable table.
We choose the backfill-14 project for doing this work to match the date (14th).

## Stage target payloads into a table

First, we create placeholder datasets and tables in the target project:

```
./mirror-prod-tables
```

Next, we stage a source table following the pbd structure and we run a
query to populate it:

```
# Copy a small pbd table (we choose core_v1) to the backfill project;
# we're going to overwrite the data, all we care about is getting the right structure.
bq cp moz-fx-data-shared-prod:payload_bytes_decoded.telemetry_telemetry__core_v1 moz-fx-data-backfill-17:payload_bytes_decoded.main_deduped

# Now we run our query to populate the table.
bq query --nouse_legacy_sql --project_id=moz-fx-data-backfill-14 --destination_table moz-fx-data-backfill-14:payload_bytes_decoded.main_deduped --replace -n 0 < query.sql
```

The query handles deduplication, so we'll be able to copy the results directly
into place in the historical ping tables (`_stable` tables). The query took
about 30 minutes to complete and scanned about 4 TB of compressed data.

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
/path/to/bigquery-backfill/backfill/2020-04-14-copy-dedupe-failure/launch-dataflow-job
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
    'main_v4' AS tbl,
    COUNT(distinct document_id) AS n_pbd
  FROM
    `moz-fx-data-shared-prod.payload_bytes_decoded.telemetry_telemetry__main_v4`
  WHERE
    DATE(submission_timestamp) = DATE "2020-04-14"
  GROUP BY
    1 ),
  live AS (
  SELECT
    'main_v4' AS tbl,
    COUNT(distinct document_id) AS n_live
  FROM
    `moz-fx-data-shared-prod.telemetry_live.main_v4`
  WHERE
    DATE(submission_timestamp) = DATE "2020-04-14"
  GROUP BY
    1 ),
  stable AS (
  SELECT
    'main_v4' AS tbl,
    COUNT(distinct document_id) AS n_stable
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.main_v4`
  WHERE
    DATE(submission_timestamp) = DATE "2020-04-14"
  GROUP BY
    1 ),
  bkf AS (
  SELECT
    'main_v4' AS tbl,
    COUNT(*) AS n_backfill,
    COUNT(distinct document_id) AS n_backfill_distinct
  FROM
    `moz-fx-data-backfill-14.telemetry_stable.main_v4`
  WHERE
    DATE(submission_timestamp) = DATE "2020-04-14"
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

All looks good.

## Finalize

We use a `bq cp` command to overwrite the
target partition in the prod stable table. The following requires elevated
privileges; currently, you need to ask :klukas or ops to run this:

```bash
bq cp -f moz-fx-data-backfill-14:telemetry_stable.main_v4\$20200414 moz-fx-data-shared-prod:telemetry_stable.main_v4\$20200414
```

If you run the above query again, you should see that `n_stable` and `n_backfill`
now match exactly.

## Cleanup

```
# BE CAREFUL! This removes all BQ datasets and GCS buckets from the target project,
# including their contents; it cannot be undone.
bq ls --project_id=moz-fx-data-backfill-14 | tail -n+3 | awk '{print $1}' | xargs -I{} -n1 bq rm -r -f "moz-fx-data-backfill-14:{}"
gsutil ls -p moz-fx-data-backfill-14 | xargs echo gsutil -m rm -r
```

And we're done!

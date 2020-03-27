We had our BQ live sinks write a number of records to error output in GCS between
2020-03-16 and 2020-03-18 while we were experiencing pipeline instability.
There were a couple of bad things that worked together to cause this:

- Our error handling code around fetching table info from the BigQuery API was
  incorrect; it should have bubbled up and shut down the worker, but instead
  caught the exceptions and wrote them silently to error output
- We started exceeding the API rate limit regularly on 2020-03-16 because
  we scaled up the structured sink to more workers that we had used before
  and we didn't realize that we were already close to hitting the API limit
  
This affected both structured and telemetry pipelines.

For structured, we want to backfill from errors for the affected days
2020-03-16 through 2020-03-18.

For telemetry, we also had Dataflow jobs failing in this time period, so we
had to do some backfills from payload_bytes_decoded, which also gets the records
that would have been recovered from this process. So, for telemetry we only need
to hit 2020-03-16.

## Stage GCS objects

Dataflow in the backfill project got permission denied attempting to read
directly from the prod error data, so let's copy the objects to a bucket
in the backfill project.

First, we need to create the bucket (done manually in the BQ console).

Now, structured:

```
for x in 2020-03-16 2020-03-17 2020-03-18
do 
  gsutil -m cp -r gs://moz-fx-data-prod-data/structured-decoded_bq-sink/error/${x}/ gs://moz-fx-data-backfill-data/structured-decoded_bq-sink/error/
done
```

And telemetry:

```
for x in 2020-03-16
do
  gsutil -m cp -r gs://moz-fx-data-prod-data/telemetry-decoded_bq-sink/error/${x}/ gs://moz-fx-data-backfill-data/telemetry-decoded_bq-sink/error/
done
```

## Create target tables

We create placeholder datasets and tables in the target project:

```
./mirror-prod-tables
```


## Run Dataflow jobs to populate temporary stable tables

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

We launch Dataflow jobs for structured and telemetry:

```
cd gcp-ingestion/ingestion-beam
/path/to/bigquery-backfill/backfill/2020-03-18-gcs-errors/launch-dataflow-job
```

That script requires slight modification for the telemetry and
structured cases. These ramped up to 1000 workers for only about 20 minutes,
then ramped down and spent a few hours waiting on BQ load jobs to complete.

## Append results to live tables

We really should have loaded the records into live-like tables rather than
stable, because the safest route here is to validate that the records in the
backfill tables look reasonable, append them to the existing prod live tables,
and then rerun copy_deduplicate to populate the stable tables.

We could have used `bq cp` commands if we had used live schemas, but we have
to use queries instead:

```
./append_results_structured
./append_results_telemetry
```

## Repopulate stable tables

Finally, we run copy_deduplicate for affected days to repopulate stable tables for structured:

```
# Pull down the bigquery-etl repository first
cd bigquery-etl/
./script/copy_deduplicate -x 'telemetry_live.*' --project-id moz-fx-data-shared-prod --billing-project moz-fx-data-backfill-11 --dates 2020-03-16 2020-03-17 2020-03-18
```

And telemetry:

```
./script/copy_deduplicate -o 'telemetry_live.*' --project-id moz-fx-data-shared-prod --billing-project moz-fx-data-backfill-11 --dates 2020-03-16
```

## Clean up


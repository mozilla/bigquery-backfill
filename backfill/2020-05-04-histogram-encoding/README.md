# Test Compact Histogram Encoding

See [Proposal: Compact String Encoding for Histograms](https://docs.google.com/document/d/1k_ji_1DB6htgtXnPpMpa7gX0klm-DGV5NMY7KkvVB00/edit#) Google Doc.

The goal here is to load a single hour of main ping data from `payload_bytes_decoded`
to `telemetry_stable.main_v4` format, and then run an experimental
version of the BQ loader which alters the string representation of histograms.
At the end, we compare the size of the two different tables.

## Stage target payloads into a table

First, we create placeholder datasets and tables in the target project:

```
./mirror-prod-tables
```

## Run a Dataflow job to populate tables

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
/path/to/bigquery-backfill/backfill/2020-05-04-histogram-encoding/launch-dataflow-job
```

## Inspect results

The control table registers as 352 GB while the one using a first version of the compact
histogram encoding registers as 163 GB, so we reduce overall storage footprint by 57%.

## Cleanup

```
# BE CAREFUL! This removes all BQ datasets and GCS buckets from the target project,
# including their contents; it cannot be undone.
bq ls --project_id=moz-fx-data-backfill-4 | tail -n+3 | awk '{print $1}' | xargs -I{} -n1 bq rm -r -f "moz-fx-data-backfill-4:{}"
gsutil ls -p moz-fx-data-backfill-4 | xargs echo gsutil -m rm -r
```

And we're done!

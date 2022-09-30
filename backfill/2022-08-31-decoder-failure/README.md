# Backfill missing structured pipeline family pings

Context:

- [tracking bug](https://mozilla-hub.atlassian.net/browse/DSRE-999)

The `structured` decoder Dataflow job entered an un-drainable state on
2022-08-31. This introduced some pipeline latency and a small amount of data loss (about ~~6 million~~
100,000 records) for that day, since
[we canceled the job](https://cloud.google.com/dataflow/docs/guides/stopping-a-pipeline).

The missing pings were recovered from
[`payload_bytes_raw`](https://docs.telemetry.mozilla.org/cookbooks/bigquery/querying.html?highlight=payload_bytes_raw#projects-with-bigquery-datasets),
the dataset we maintain for reprocessing of raw data in case of decoder failure.

The purpose of this backfill is to get the missing pings from the affected period
integrated into stable tables and downstream derived tables.

## Step 1: Set up backfill project

Data SRE prepared terraform for staging source and output tables to project
`moz-fx-data-backfill-10` ([cloudops-infra PR](https://github.com/mozilla-services/cloudops-infra/pull/4356))
including the following query logic for populating the staging source:

```
WITH raw_documents AS (
  SELECT
      *,
      split(uri, "/")[safe_offset(5)] AS document_id,
  FROM `moz-fx-data-shared-prod.payload_bytes_raw.structured`
  WHERE DATE(submission_timestamp) = "2022-08-31" # time of incident / document loss
), live_documents AS (
  SELECT DISTINCT document_id
  FROM `moz-fx-data-shared-prod.payload_bytes_decoded.structured_*`
  WHERE DATE(submission_timestamp) = "2022-08-31" # time of incident / document loss
)
SELECT raw_documents.* EXCEPT (document_id) FROM raw_documents
LEFT JOIN live_documents USING (document_id)
WHERE live_documents.document_id IS NULL
```

The staging data was written to `moz-fx-data-backfill-10.payload_bytes_raw.backfill`

Note: because `payload_bytes_raw` contains raw data (including e.g. IP
addresses), it isn't considered `workgroup:mozilla-confidential` and access to
the data in the backfill project will be restricted to individual Data
Engineers responsible for the following steps.

## Step 2: Run Dataflow job to populate live staging tables

See the script in this directory for the invocation to run the Decoder backfill
job to populate the staging live tables.

With a local working copy of `gcp-ingestion` in sync with `main`, run the [`02-gcp-ingestion-beam-decoder.sh` script](02-gcp-ingestion-beam-decoder.sh) to start the decoder as a Dataflow job:

```bash
cd path/to/gcp-ingestion

path/to/02-gcp-ingestion-beam-decoder.sh
```

**⚠** While attempting to run this we ran into a bunch of Java build
issues. Various DE were unable to build and run the ingestion code, but one
eventually succeeded. We made a note to switch to using the pre-built flex
templates for future backfills, and to improve gcp-ingestion documentation
where applicable to make bootstrapping easier.

## OPTIONAL: Set up a GCP instance in the backfill project to run API calls from

This is advisable if you're running a lot of API calls from an unreliable
network, such as conference WiFi.

This can be done from the GCP web console if you're an Editor on the project:
make sure to use the default service account and enable all scopes so that the
instance can make API calls.

```bash
gcloud compute instances create dsre-999-backfill --project=moz-fx-data-backfill-10 --zone=us-west1-b --machine-type=e2-standard-4 --network-interface=subnet=default,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --service-account=339436751542-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --create-disk=auto-delete=yes,boot=yes,device-name=dsre-999-backfill,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220920,mode=rw,size=10,type=projects/moz-fx-data-backfill-10/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```

To SSH into the instance once it has been created, run:

```
gcloud compute ssh --zone "us-west1-b" "dsre-999-backfill"  --tunnel-through-iap --project "moz-fx-data-backfill-10"
```

## Step 3: Copy & deduplicate decoded pings

1. Determine which staging live tables need to be processed and update the script in this directory

```bash
bq query --format csv --nouse_legacy_sql 'SELECT FORMAT("%s.%s", table_schema, table_name) as table_id FROM `moz-fx-data-backfill-10.region-us.INFORMATION_SCHEMA.TABLE_STORAGE_BY_PROJECT` WHERE creation_time > "2022-08-31" and table_schema LIKE "%_live" and total_rows > 0;'
```

Note: the `creation_time` filter shouldn't strictly be necessary but
information schema metadata tables appear to contain possibly stale metadata
from deleted tables such as from the [last backfill that was run from this project](https://github.com/mozilla/bigquery-backfill/pull/18).

**⚠** At this point, we decided to count the number of records processed by the
batch job and determined that the number of documents successfully decoded was
much lower than the number of input records, while the number of errors decoded
accounted for the vast majority of processed records. About ~90,000 records
were successfully decoded while the remaining 5M+ records went to the backfill
errors table. After some investigation of various dashboards, we determined
that the initial query we used to populate the backfill input included a larger
set of errors than those that actually needed to be reprocessed, since it was
not filtering out document ids from the errors table that were successfully
processed by the decoder into the errors table.

With this in mind, we decided to continue with the remaining steps, but to
amend step 5.3. below to only append the specific new error records to
`moz-fx-data-shared-prod.payload_bytes_error.structured`.

**⚠** While debugging we determined that it would be useful for DE to have
access to read all BQ job logs from, so we decided to update the bootstrapping
in step 1 to include granting `roles/bigquery.resourceViewer` which includes
the requisite access.

2. Run the script in this directory for the invocation of relevant `copy_deduplicate` queries:

```bash
cd path/to/bigquery-etl

./path/to/03-bigquery-etl-copy-deduplicate.sh
```

**⚠** While running this step we ran into an allowlist issue similar to
https://github.com/mozilla/bigquery-etl/pull/3208 where backfill projects are
rejected by bigquery-etl code as invalid. We hard-coded a workaround with the
intent to add backfill projects to the allowlist in the future.

## Step 4: Insert previously missing pings into production tables

Because of the way the initial backfill query was structured, we should be guaranteed that documents we're processing in this backfill don't correspond to an existing document in the stable tables, and so a direct append of affected records should be acceptable.

To insert the previously missing pings into production stable tables, someone with appropriate access can run the following commands either in Google Cloud Shell or using the Google Cloud SDK:

1. Determine which staging stable tables need to be processed and update the script in this directory

```bash
bq query --format csv --nouse_legacy_sql 'SELECT FORMAT("%s.%s", table_schema, table_name) as table_id FROM `moz-fx-data-backfill-10.region-us.INFORMATION_SCHEMA.TABLE_STORAGE_BY_PROJECT` WHERE creation_time > "2022-08-31" and table_schema LIKE "%_stable" and total_rows > 0;'
```

2. Run the script in this directory for the invocation of relevant `bq append` statements:

```bash
./path/to/04-append-to-prod-stable-tables.sh
```

## Step 5: Clean up

1.  DE will remove any GCS buckets created by Dataflow jobs:

    ```bash
    # BE CAREFUL!  This removes all GCS buckets from the target project.  It cannot be undone.

    gsutil ls -p moz-fx-data-backfill-10 | xargs gsutil -m rm -r
    ```

    Log:

    ```
    ...
    Operation completed over 250 objects.
    Removing gs://dataflow-staging-us-central1-339436751542/...
    ```

2. DE will delete any GCE instances created to facilitate the backfill:

    ```bash
    gcloud compute instances delete --zone="us-west1-b" "dsre-999-backfill" --project "moz-fx-data-backfill-10"
    ```

3.  Data SRE will copy errors from the backfill back into the prod error table:

    **⚠** The command we intended to run was:
    ```bash
    bq cp --append_table moz-fx-data-backfill-10:payload_bytes_error.structured moz-fx-data-shared-prod:payload_bytes_error.structured
    ```

    But in order to filter out the excess records identified in step 3.1, we
    wrote the following query to filter results to `moz-fx-data-backfill-10:payload_bytes_error.backfill`:

    ```sql
    WITH error_documents AS (
      SELECT
          *,
          split(uri, "/")[safe_offset(5)] AS document_id,
      FROM `moz-fx-data-backfill-10.payload_bytes_error.structured`
      WHERE DATE(submission_timestamp) = "2022-08-31" # time of incident / document loss
    ), prod_error_documents AS (
      SELECT
          *,
          DISTINCT split(uri, "/")[safe_offset(5)] AS document_id,
      FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
      WHERE DATE(submission_timestamp) = "2022-08-31" # time of incident / document loss
    )
    SELECT error_documents.* EXCEPT (document_id) FROM error_documents
    LEFT JOIN prod_error_documents USING (document_id)
    WHERE prod_error_documents.document_id IS NULL
    ```

    And then run:

    ```bash
    bq cp --append_table moz-fx-data-backfill-10:payload_bytes_error.backfill moz-fx-data-shared-prod:payload_bytes_error.structured
    ```

    This produced 3,502 records, much more in line with our expectations.

4.  Finally, Data SRE will remove the resources that were created for this backfill with Terraform using Terraform (note that this also removes DE editor access to the backfill GCP project).

## Step 6: Re-run ETL?

Because the number of records that were missing ended up being even smaller
than we have expected (91,169), we decided that re-running downstream ETL via
Airflow for the affected day was unnecessary and that these documents would
therefore only be available via the stable tables. We decided to add a note to the
[notable historical events](https://docs.telemetry.mozilla.org/concepts/analysis_gotchas.html?highlight=gotchas#notable-historic-events)
page mentioning this as the final resolution to this backfill.

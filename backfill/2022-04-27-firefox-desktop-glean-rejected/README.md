# Backfill rejected firefox-desktop glean pings

Context:

- [tracking bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1766424)
- [incident doc](https://docs.google.com/document/d/1QX13O-ivVRlZLUm7uAYSxE7UQLBoG4VSd-4ixx8yjgg/edit#)
- [gcp-ingestion pipeline change](https://github.com/mozilla/gcp-ingestion/pull/2064)

We started rejecting all `firefox-desktop` glean pings from nightly versions of
desktop Firefox that had upgraded to a version of Glean that no longer sent a
custom `User-Agent` header. The `MessageScrubber` filter that was causing those
to be dropped was changed on 2022-04-27 and we have confirmed that pings are now
correctly flowing.

The purpose of this backfill is to get the rejected pings from the affected period
integrated into stable tables and downstream derived tables.

NOTE: We ended up with a bit of extra complexity here because we ran the backfill
including the current (incomplete) day. That's called out in steps 3 and 4.

## Step 1: Set up backfill project

Data SRE prepared terraform for staging source and output tables to project
`moz-fx-data-shared-prod` ([cloudops-infra PR](https://github.com/mozilla-services/cloudops-infra/pull/4019))
including the following query logic for populating the staging source:

```
SELECT
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE
  DATE(submission_timestamp) BETWEEN '2022-04-12' AND '2022-04-27'
  AND document_namespace = 'firefox-desktop'
  AND error_message LIKE 'com.mozilla.telemetry.decoder.MessageScrubber$UnwantedDataException: 1684980'
```

## Step 2: Run Dataflow job to populate live staging tables

See the script in this directory for the invocation to run the Decoder backfill
job to populate the staging live tables.

With a local working copy of `gcp-ingestion` in sync with `main`, run the [`02-gcp-ingestion-beam-decoder.sh` script](02-gcp-ingestion-beam-decoder.sh) to start the decoder as a Dataflow job:

```bash
cd path/to/gcp-ingestion

path/to/02-gcp-ingestion-beam-decoder.sh
```

This ran successfully in 12 minutes with following output:

- Errors: 611425
- baseline: 4652551
- deletion_request: 8188
- events: 2553799
- fog_validation: 0
- metrics: 431974

Adding those together: `431974 + 2553799 + 8188 + 4652551 + 611425 = 8257937` so
all pings are accounted for; the number in the source table matches the outputs.

## Step 3: Copy & deduplicate decoded pings

Run the script in this directory for the invocation of relevant `copy_deduplicate` queries:

```bash
cd path/to/bigquery-etl

./path/to/03-bigquery-etl-copy-deduplicate.sh
```

## Step 4: Insert previously rejected pings into production tables

To insert the previously rejected pings into production stable tables, someone with appropriate access can run the following `bq` commands either in Google Cloud Shell or using the Google Cloud SDK:

```bash
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_stable.baseline_v1 moz-fx-data-shared-prod:firefox_desktop_stable.baseline_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_stable.deletion_request_v1 moz-fx-data-shared-prod:firefox_desktop_stable.deletion_request_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_stable.events_v1 moz-fx-data-shared-prod:firefox_desktop_stable.events_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_stable.fog_validation_v1 moz-fx-data-shared-prod:firefox_desktop_stable.fog_validation_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_stable.metrics_v1 moz-fx-data-shared-prod:firefox_desktop_stable.metrics_v1
```

For the current day, we have to append into live tables instead:

```bash
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_live.baseline_v1'$20220427' moz-fx-data-shared-prod:firefox_desktop_live.baseline_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_live.deletion_request_v1'$20220427' moz-fx-data-shared-prod:firefox_desktop_live.deletion_request_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_live.events_v1'$20220427' moz-fx-data-shared-prod:firefox_desktop_live.events_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_live.fog_validation_v1'$20220427' moz-fx-data-shared-prod:firefox_desktop_live.fog_validation_v1
bq cp --append_table moz-fx-data-backfill-10:firefox_desktop_live.metrics_v1'$20220427' moz-fx-data-shared-prod:firefox_desktop_live.metrics_v1
```

## Step 5:  Clean up

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

2.  Data SRE will delete the errors for the payloads that have now been successfully ingested:

```sql
DELETE FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE
  DATE(submission_timestamp) BETWEEN '2022-04-12' AND '2022-04-27'
  AND document_namespace = 'firefox-desktop'
  AND error_message LIKE 'com.mozilla.telemetry.decoder.MessageScrubber$UnwantedDataException: 1684980'
```

This in practice produced an error message:

> UPDATE or DELETE statement over table moz-fx-data-shared-prod.payload_bytes_error.structured would affect rows in the streaming buffer, which is not supported

We modified this to not affect the current day (made the end date 2022-04-26) to get around the problem. This deleted 8,023,263 rows.

We'll need to circle back to this after 2022-04-27 is complete to delete the final day:

```sql
DELETE FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE
  DATE(submission_timestamp) = '2022-04-27'
  AND document_namespace = 'firefox-desktop'
  AND error_message LIKE 'com.mozilla.telemetry.decoder.MessageScrubber$UnwantedDataException: 1684980'
```

This statement removed 246,571 rows from structured.

Per https://cloud.google.com/bigquery/streaming-data-into-bigquery it can take up to 90 minutes
for the streaming buffer to be fully flushed after new records stop flowing in.

3.  Data SRE will copy errors from the backfill back into the prod error table:

```bash
bq cp --append_table moz-fx-data-backfill-10:payload_bytes_error.structured moz-fx-data-shared-prod:payload_bytes_error.structured
```

BUT: after we ran this we realized we missed some nuance.
Because the initial copy step into ``moz-fx-data-backfill-10.payload_bytes_error.backfill`` was run before the end of the 2022-04-27 UTC day, this should have had an additional filter to avoid deleting all `UnwantedDataException: 1684980` errors that happened after that point.

To fix that up, we use time travel:

```
CREATE TABLE `moz-fx-data-backfill-10.payload_bytes_error.backfill_fix`
 PARTITION BY DATE(submission_timestamp)
 CLUSTER BY
   submission_timestamp
 AS SELECT * FROM `moz-fx-data-backfill-10:payload_bytes_error.backfill` LIMIT 0;

SELECT *
FROM `payload_bytes_error.structured`
  FOR SYSTEM_TIME AS OF "2022-04-28 01:00:00.000000 UTC"
where date(submission_timestamp) = "2022-04-27" and submission_timestamp > (SELECT MAX(submission_timestamp) FROM `moz-fx-data-backfill-10.payload_bytes_error.backfill` where date(submission_timestamp) = "2022-04-27")
  AND document_namespace = 'firefox-desktop'
  AND error_message LIKE 'com.mozilla.telemetry.decoder.MessageScrubber$UnwantedDataException: 1684980'
```

This may still miss a few pings, but will be very nearly complete. We append this content (11897 records) to the prod errors table:

```
bq cp -a 'moz-fx-data-backfill-10:payload_bytes_error.backfill_fix' 'moz-fx-data-shared-prod:payload_bytes_error.structured'
```

4.  Finally, Data SRE will remove the resources that were created for this backfill with Terraform using Terraform (note that this also removes DE editor access to the backfill GCP project).


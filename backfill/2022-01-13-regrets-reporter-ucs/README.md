# Backfill rejected events from RegretsReporter extension between 2021-11-17 and 2022-01-09

  - [Bug 1748284](https://bugzilla.mozilla.org/show_bug.cgi?id=1748284): Schema validation errors for timestamps in regrets-reporter-ucs main-events pings
  - GCP project used:  `moz-fx-data-backfill-10`


## Context

  - [Glean.js v0.17.0](https://github.com/mozilla/glean.js/releases/tag/v0.17.0) was released on 2021-07-16 with a [change](https://github.com/mozilla/glean.js/commit/3ea07fc885a83f825d553040c91f12eb2fd63837#diff-952bad66acb1e3eeaf5fb239a29962bf4d4b7abe8e3343dd4245dbd6d818c04cR174) that caused event timestamps to have floating point values when [`performance.now()`](https://developer.mozilla.org/en-US/docs/Web/API/Performance/now) is available.
  - [RegretsReporter v2.0.3](https://github.com/mozilla-extensions/regrets-reporter/releases/tag/v2.0.3) was released on 2021-12-03 [using Glean.js v0.27.0](https://github.com/mozilla-extensions/regrets-reporter/blob/v2.0.3/package.json#L33).
  - On 2021-12-03 tens of thousands of RegretsReporter event payloads began to be rejected every day by the ingestion pipeline during [payload parsing](https://github.com/mozilla/gcp-ingestion/blob/e6783df9140fcfcb8c9bf805860f9d3796398dc6/ingestion-beam/src/main/java/com/mozilla/telemetry/decoder/ParsePayload.java#L164) due to the contained events having non-integer timestamp values, when [the pipeline schemas require the event timestamp values to be integers](https://github.com/mozilla-services/mozilla-pipeline-schemas/blob/ef1f203513ef03fc22b9ca5a2ac0f93093078967/schemas/regrets-reporter-ucs/main-events/main-events.1.schema.json#L117).
    - Example error message: `org.everit.json.schema.ValidationException: #/events/1/timestamp: expected type: Integer, found: Double`
    - A smaller number of such RegretsReporter event payloads were rejected between 2021-11-17 and 2021-12-02, likely from testing RegretsReporter v2 prior to release.
  - [Glean.js v0.29.0](https://github.com/mozilla/glean.js/releases/tag/v0.29.0) was released on 2022-01-04 with a [fix](https://github.com/mozilla/glean.js/commit/d9a005f1902b08c38187c190181490c477ad5ff4#diff-952bad66acb1e3eeaf5fb239a29962bf4d4b7abe8e3343dd4245dbd6d818c04cR191) to make all event timestamps have integer values.
  - [RegretsReporter v2.0.5](https://github.com/mozilla-extensions/regrets-reporter/releases/tag/v2.0.5) was released on 2022-01-04 which [upgraded its Glean.js to v0.29.0](https://github.com/mozilla-extensions/regrets-reporter/compare/v2.0.4...v2.0.5#diff-7ae45ad102eab3b6d7e7896acd08c427a9b25b346470d7bc6507b6481575d519R33).
  - On 2022-01-07 the number of such RegretsReporter event payloads being rejected dropped to less than ten thousand per day.
  - As of 2022-01-14 there continue to be hundreds of such RegretsReporter event payloads being rejected per day, but that volume is low enough to not be a serious concern.


## Step 1:  Set up backfill GCP project

The rejected RegretsReporter event payloads to be used as the source of the backfill were in `moz-fx-data-shared-prod:payload_bytes_error.structured`, which has restricted access, and the destination tables in `moz-fx-data-shared-prod:regrets_reporter_ucs_stable` also have restricted access.

To work around those restrictions, [Data SRE used Terraform](https://github.com/mozilla-services/cloudops-infra/pull/3694) to:
  - Copy the applicable `moz-fx-data-shared-prod.payload_bytes_error.structured` rows to `moz-fx-data-backfill-10.payload_bytes_error.structured`.
  - Create "live" tables for the payload decoder output in the `moz-fx-data-backfill-10.regrets_reporter_ucs_live` dataset.
  - Create a `moz-fx-data-backfill-10.payload_bytes_error.backfill` table for any payload decoder errors encountered during the backfill.
  - Create "stable" tables for the final backfill output in the `moz-fx-data-backfill-10.regrets_reporter_ucs_stable` dataset.

Some gotchas we ran into:
  - In order for the Dataflow jobs to run in the `moz-fx-data-backfill-10` project the default compute service account needed to be granted access to the project.
  - The "live" tables in the `moz-fx-data-backfill-10.regrets_reporter_ucs_live` dataset were created with their partition expiration set to 30 days, so that needed to be increased to accommodate the data going back to 2021-11-17.


## Step 2:  Decode rejected RegretsReporter event payloads

The payload parsing code needed to be temporarily modified for the backfill to deal with the floating point timestamps.
The modified code was published to [gcp-ingestion/bug-1748284-backfill](https://github.com/mozilla/gcp-ingestion/compare/c67c21a7f919b86fb1b764909f3d96380fb68745...bug-1748284-backfill), but in case that branch gets pruned the code modification is also saved in [`02-gcp-ingestion.diff`](02-gcp-ingestion.diff).

With a local working copy of `gcp-ingestion` thus modified, run the [`02-gcp-ingestion-beam-decoder.sh` script](02-gcp-ingestion-beam-decoder.sh) to start the decoder as a Dataflow job:

```bash
cd path/to/gcp-ingestion

path/to/bigquery-backfill/backfill/2022-01-13-regrets-reporter-ucs/02-gcp-ingestion-beam-decoder.sh
```

That decoder job is configured to populate the tables in the `moz-fx-data-backfill-10.regrets_reporter_ucs_live` dataset and write any errors to the `moz-fx-data-backfill-10.payload_bytes_error.backfill` table.

Output:
  - 822,830 `moz-fx-data-backfill-10.regrets_reporter_ucs_live.main_events_v1` rows.
  - 2 `moz-fx-data-backfill-10.regrets_reporter_ucs_live.video_index_v1` rows.


## Step 3:  Copy & deduplicate decoded RegretsReporter events

To copy and deduplicate the rows from the "live" tables in the `moz-fx-data-backfill-10.regrets_reporter_ucs_live` dataset into the "stable" tables in the `moz-fx-data-backfill-10.regrets_reporter_ucs_stable` dataset, run the [`03-bigquery-etl-copy-deduplicate.sh` script](03-bigquery-etl-copy-deduplicate.sh):

```bash
cd path/to/bigquery-etl

path/to/bigquery-backfill/backfill/2022-01-13-regrets-reporter-ucs/03-bigquery-etl-copy-deduplicate.sh
```

Output:
  - 822,368 `moz-fx-data-backfill-10.regrets_reporter_ucs_stable.main_events_v1` rows.
  - 2 `moz-fx-data-backfill-10.regrets_reporter_ucs_stable.video_index_v1` rows.


## Step 4:  Insert previously rejected RegretsReporter events into production tables

To insert the previously rejected RegretsReporter events into production tables, someone with appropriate access can run the following `bq` commands either in Google Cloud Shell or using the Google Cloud SDK:

```bash
bq cp --append_table moz-fx-data-backfill-10:regrets_reporter_ucs_live.main_events_v1 moz-fx-data-shared-prod:regrets_reporter_ucs_live.main_events_v1

bq cp --append_table moz-fx-data-backfill-10:regrets_reporter_ucs_live.video_index_v1 moz-fx-data-shared-prod:regrets_reporter_ucs_live.video_index_v1

bq cp --append_table moz-fx-data-backfill-10:regrets_reporter_ucs_stable.main_events_v1 moz-fx-data-shared-prod:regrets_reporter_ucs_stable.main_events_v1

bq cp --append_table moz-fx-data-backfill-10:regrets_reporter_ucs_stable.video_index_v1 moz-fx-data-shared-prod:regrets_reporter_ucs_stable.video_index_v1
```

Output:
  - 822,830 `moz-fx-data-shared-prod.regrets_reporter_ucs_live.main_events_v1` rows.
  - 2 `moz-fx-data-shared-prod.regrets_reporter_ucs_live.video_index_v1` rows.
  - 822,368 `moz-fx-data-shared-prod.regrets_reporter_ucs_stable.main_events_v1` rows.
  - 2 `moz-fx-data-shared-prod.regrets_reporter_ucs_stable.video_index_v1` rows.


## Step 5:  Clean up

1.  DE will remove any GCS buckets created by Dataflow jobs:

    ```bash
    # BE CAREFUL!  This removes all GCS buckets from the target project.  It cannot be undone.

    gsutil ls -p moz-fx-data-backfill-10 | xargs gsutil -m rm -r
    ```

2.  Data SRE will remove the [resources that were created for this backfill with Terraform](https://github.com/mozilla-services/cloudops-infra/pull/3694) using Terraform (note that this also removes DE editor access to the backfill GCP project).

3.  Data SRE will delete the errors for the RegretsReporter payloads that have now been successfully ingested:

    ```sql
    DELETE FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
    WHERE
      DATE(submission_timestamp) BETWEEN '2021-11-01' AND '2022-01-09'
      AND document_namespace = 'regrets-reporter-ucs'
      AND error_message LIKE 'org.everit.json.schema.ValidationException%Double'
    ```

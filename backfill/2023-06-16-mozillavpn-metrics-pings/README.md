# Backfill rejected `mozillavpn.metrics` pings between 2022-10-26 and 2023-06-09

  - [DENG-996](https://mozilla-hub.atlassian.net/browse/DENG-996): Recover mozilla_vpn metrics ping data
  - GCP project used:  `moz-fx-data-backfill-3`


## Context

  - The Mozilla VPN apps initially used [Glean.js](https://github.com/mozilla/glean.js/) for telemetry, which didn't support all the Glean ping types, notably `metrics` pings.
  - In October 2022 a process of migrating the Mozilla VPN apps to use the Glean Rust & mobile SDKs began ([VPN-3021](https://mozilla-hub.atlassian.net/browse/VPN-3021)).
  - When the Mozilla VPN mobile apps started using native Glean SDKs, the native Glean SDK pings were recorded under new Glean app IDs:
    - `org.mozilla.firefox.vpn` for Android ([probe-scraper#450](https://github.com/mozilla/probe-scraper/pull/450))
    - `org.mozilla.ios.FirefoxVPN` for iOS ([probe-scraper#584](https://github.com/mozilla/probe-scraper/pull/584))
  - When the Mozilla VPN desktop apps started using native Glean SDKs, the native Glean SDK pings were recorded under the original `mozillavpn` Glean app ID used with Glean.js.  However, since the [`mozillavpn` Glean app definition was still based on Glean.js](https://github.com/mozilla/probe-scraper/blob/860ec248ec05e669c17049ff6599d6d368b15be7/repositories.yaml#L863), all `metrics` pings were being rejected with `com.mozilla.telemetry.ingestion.core.schema.SchemaNotFoundException` errors.
  - On 2023-06-08 the `mozillavpn` Glean app definition was updated to be based on Glean core ([probe-scraper#597](https://github.com/mozilla/probe-scraper/pull/597)), and when that change took effect on 2023-06-09 `metrics` pings started being successfully recorded for the `mozillavpn` app.


## Step 1:  Set up backfill GCP project

Data SRE provisioned the `moz-fx-data-backfill-3` project for this backfill on 2023-06-13 using Terraform ([cloudops-infra#4931](https://github.com/mozilla-services/cloudops-infra/pull/4931)).

  - The 431,239 `mozillavpn.metrics` pings rejected between 2022-10-26 and 2023-06-09 were copied from `moz-fx-data-shared-prod.payload_bytes_error.structured` into the `moz-fx-data-backfill-3.payload_bytes_error.backfill` table.
  - The partition expiration on the `moz-fx-data-backfill-3.mozillavpn_live.metrics_v1` table was increased from the default 30 days for live tables to 180 days to match the partition expiration of the ultimate target table, `moz-fx-data-backfill-3.mozillavpn_stable.metrics_v1`.


## Step 2:  Decode rejected `mozillavpn.metrics` ping payloads

Run the [`02-gcp-ingestion-beam-decoder.sh` script](02-gcp-ingestion-beam-decoder.sh) to start the decoder as a Dataflow job:

```bash
cd path/to/gcp-ingestion

path/to/bigquery-backfill/backfill/2023-06-16-mozillavpn-metrics-pings/02-gcp-ingestion-beam-decoder.sh
```

That decoder job is configured to populate the tables in the `moz-fx-data-backfill-3.mozillavpn_live` dataset and write any errors to the `moz-fx-data-backfill-3.payload_bytes_error.structured` table.

### Output (2023-06-16):
  - 422,921 `moz-fx-data-backfill-3.mozillavpn_live.metrics_v1` rows between 2022-12-20 and 2023-06-09.
    - 3,203 rows were before the 180-day partition expiration cutoff of 2022-12-18 and weren't saved.
  - 5,115 errors in `moz-fx-data-backfill-3.payload_bytes_error.structured`.
    - 5,111 `org.everit.json.schema.ValidationException: #/client_info: required key [app_build] not found`
    - 3 `org.everit.json.schema.ValidationException: #/client_info: required key [architecture] not found`
    - 1 `org.everit.json.schema.ValidationException: #/client_info: required key [app_display_version] not found`


## Step 3:  Copy & deduplicate decoded `mozillavpn.metrics` pings

To copy and deduplicate the rows from the "live" tables in the `moz-fx-data-backfill-3.mozillavpn_live` dataset into the "stable" tables in the `moz-fx-data-backfill-3.mozillavpn_stable` dataset, run the [`03-bigquery-etl-copy-deduplicate.sh` script](03-bigquery-etl-copy-deduplicate.sh):

```bash
cd path/to/bigquery-etl

path/to/bigquery-backfill/backfill/2023-06-16-mozillavpn-metrics-pings/03-bigquery-etl-copy-deduplicate.sh
```

### Output (2023-06-16):
  - 422,726 `moz-fx-data-backfill-3.mozillavpn_stable.metrics_v1` rows between 2022-12-20 and 2023-06-09.


## Step 4:  Insert new `mozillavpn.metrics` pings and errors into production tables

To insert the previously rejected `mozillavpn.metrics` pings and new decoder errors into production tables, someone with appropriate access can run the following `bq` commands either in Google Cloud Shell or using the Google Cloud SDK:

```bash
# The target live table's partition expiration is set to 30 days, so it's expected that most of the copied rows will immediately expire.
# However, this is the easiest way to copy the data, and the data volume is very small so cost is not a factor.
bq cp --append_table moz-fx-data-backfill-3:mozillavpn_live.metrics_v1 moz-fx-data-shared-prod:mozillavpn_live.metrics_v1

bq cp --append_table moz-fx-data-backfill-3:mozillavpn_stable.metrics_v1 moz-fx-data-shared-prod:mozillavpn_stable.metrics_v1

bq cp --append_table moz-fx-data-backfill-3:payload_bytes_error.structured moz-fx-data-shared-prod:payload_bytes_error.structured
```

### Output (2023-06-20):
  - 422,868 `moz-fx-data-shared-prod.mozillavpn_live.metrics_v1` rows added between 2022-12-22 and 2023-06-09.
  - 422,673 `moz-fx-data-shared-prod.mozillavpn_stable.metrics_v1` rows added between 2022-12-22 and 2023-06-09.
  - 5,115 `moz-fx-data-shared-prod.payload_bytes_error.structured` rows added.


## Step 5:  Clean up

1.  DE will remove any GCS buckets created by Dataflow jobs:

    ```bash
    # BE CAREFUL!  This removes all GCS buckets from the target project.  It cannot be undone.

    gsutil ls -p moz-fx-data-backfill-3 | xargs gsutil -m rm -r
    ```

2.  Data SRE will remove the [resources that were created for this backfill with Terraform](https://github.com/mozilla-services/cloudops-infra/pull/4931) (note that this also removes DE editor access to the backfill GCP project).

3.  Data SRE will delete the `mozillavpn.metrics` ping errors that have now been processed:

    ```sql
    DELETE FROM `moz-fx-data-shared-prod.payload_bytes_error.structured`
    WHERE DATE(submission_timestamp) BETWEEN '2022-10-26' AND '2023-06-09'
      AND document_namespace = 'mozillavpn'
      AND document_type = 'metrics'
      AND exception_class = 'com.mozilla.telemetry.ingestion.core.schema.SchemaNotFoundException'
    ```

### Output (2023-06-21):
  - 431,239 `moz-fx-data-shared-prod.payload_bytes_error.structured` rows deleted.

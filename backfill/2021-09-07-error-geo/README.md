# Reprocess from payload_bytes_raw due to incorrect IP lookup

See https://bugzilla.mozilla.org/show_bug.cgi?id=1729069

Last time we needed to reprocess geo was
https://github.com/mozilla/bigquery-backfill/tree/main/backfill/2020-02-07-error-geo


## Setup

```
gcloud auth application-default login
```


## Stub installer


Let's do all of the `stub_installer` pipeline family backfill, since the data size is so small.

First, we backfill from the standard PBR table for stub_installer:

```
PROJECT="moz-fx-data-backfill-6"
JOB_NAME="geo-backfill"
PIPELINE_FAMILY="stub_installer"

## this script assumes it's being run from the ingestion-beam directory
## of the gcp-ingestion repo.

mvn clean compile exec:java -Dexec.mainClass=com.mozilla.telemetry.Decoder -Dexec.args="\
    --runner=Dataflow \
    --jobName=$JOB_NAME \
    --project=$PROJECT \
    --geoCityDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-City/20210903/GeoIP2-City.mmdb \
    --geoIspDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-ISP/20210903/GeoIP2-ISP.mmdb \
    --geoCityFilter=gs://moz-fx-data-prod-dataflow-templates/cities15000.txt \
    --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202109030341_302c86e7.tar.gz \
    --inputType=bigquery_table \
    --input=\"moz-fx-data-shared-prod:payload_bytes_raw.${PIPELINE_FAMILY}\" \
    --bqReadMethod=storageapi \
    --outputType=bigquery \
    --bqRowRestriction=\"CAST(submission_timestamp AS DATE) BETWEEN '2021-08-20' AND '2021-09-03'\"
    --bqWriteMethod=file_loads \
    --bqClusteringFields=submission_timestamp \
    --output=${PROJECT}:\${document_namespace}_live.\${document_type}_v\${document_version} \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:payload_bytes_error.${PIPELINE_FAMILY} \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=false \
    --gcsUploadBufferSizeBytes=16777216 \
"
```

We save off this result:
```
bq cp moz-fx-data-backfill-6:firefox_installer_live.install_v1 moz-fx-data-backfill-6:firefox_installer_live.install_v1_from_pbr
```

And then truncate the table:

```
TRUNCATE TABLE `moz-fx-data-backfill-6.firefox_installer_live.install_v1` 
```

Now we create a one-off table for populating from the extra snapshot:

```
CREATE TABLE
  `moz-fx-data-backfill-6.firefox_installer_live.install_v1_from_snapshot` 
  LIKE `moz-fx-data-backfill-6.firefox_installer_live.install_v1`
```

And kick off that job to read from `moz-fx-data-shared-prod:payload_bytes_raw.stub_installer_snapshot_bug1729069`:

```
PROJECT="moz-fx-data-backfill-6"
JOB_NAME="geo-backfill-stub-old"
PIPELINE_FAMILY="stub_installer"

## this script assumes it's being run from the ingestion-beam directory
## of the gcp-ingestion repo.

mvn clean compile exec:java -Dexec.mainClass=com.mozilla.telemetry.Decoder -Dexec.args="\
    --runner=Dataflow \
    --jobName=$JOB_NAME \
    --project=$PROJECT \
    --geoCityDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-City/20210903/GeoIP2-City.mmdb \
    --geoIspDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-ISP/20210903/GeoIP2-ISP.mmdb \
    --geoCityFilter=gs://moz-fx-data-prod-dataflow-templates/cities15000.txt \
    --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202109030341_302c86e7.tar.gz \
    --inputType=bigquery_table \
    --input=\"moz-fx-data-shared-prod:payload_bytes_raw.stub_installer_snapshot_bug1729069\" \
    --bqReadMethod=storageapi \
    --outputType=bigquery \
    --bqRowRestriction=\"CAST(submission_timestamp AS DATE) BETWEEN '2021-08-10' AND '2021-08-19'\"
    --bqWriteMethod=file_loads \
    --bqClusteringFields=submission_timestamp \
    --output=${PROJECT}:\${document_namespace}_live.\${document_type}_v\${document_version} \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:payload_bytes_error.${PIPELINE_FAMILY} \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=false \
    --gcsUploadBufferSizeBytes=16777216 \
"
```


## Gotchas

Permissions issues when trying to set up tables in the backfill project:

```
+ bq query --nouse_legacy_sql 'CREATE OR REPLACE TABLE `moz-fx-data-backfill-6.contextual_services_live.quicksuggest_click_v1` LIKE `moz-fx-data-shared-prod.contextual_services_live.quicksuggest_click_v1`'
BigQuery error in query operation: Error processing job 'moz-fx-data-shared-prod:bqjob_r6228d0d1b75d8b59_0000017bc16718cb_1': Access
Denied: Table moz-fx-data-shared-prod:contextual_services_live.quicksuggest_click_v1: User does not have permission to query table
moz-fx-data-shared-prod:contextual_services_live.quicksuggest_click_v1.
```

My own user can't access the contextual_services tables, or the regrets_reporter table in telemetry.

Also, permissions on the destination live tables in the backfill project are going to allow viewing by all data eng, even the ones that should be more locked down. That's another area where we'll need to think critically and improve backfill processes.


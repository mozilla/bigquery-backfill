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

### Permissions on live tables

Permissions issues when trying to set up tables in the backfill project:

```
+ bq query --nouse_legacy_sql 'CREATE OR REPLACE TABLE `moz-fx-data-backfill-6.contextual_services_live.quicksuggest_click_v1` LIKE `moz-fx-data-shared-prod.contextual_services_live.quicksuggest_click_v1`'
BigQuery error in query operation: Error processing job 'moz-fx-data-shared-prod:bqjob_r6228d0d1b75d8b59_0000017bc16718cb_1': Access
Denied: Table moz-fx-data-shared-prod:contextual_services_live.quicksuggest_click_v1: User does not have permission to query table
moz-fx-data-shared-prod:contextual_services_live.quicksuggest_click_v1.
```

My own user can't access the contextual_services tables, or the regrets_reporter table in telemetry.

Also, permissions on the destination live tables in the backfill project are going to allow viewing by all data eng, even the ones that should be more locked down. That's another area where we'll need to think critically and improve backfill processes.

### Number of destination datasets/tables

The `structured` jobs failed due to rate limiting on calls to get dataset info and listing
tables within datasets. This is likely due to having many more Glean applications than
in previous backfills. I ended up removing the section of code in `KeyByBigQueryTableDestination`
that checks for table existence in order to get around this.

### Failed to advance reader

The telemetry job for 2021-08-31 failed with:

```

Workflow failed. Causes: S35:Read.BigQueryInput/BigQueryIO.TypedRead/Read(BigQueryStorageTableSource)+ParseProxy/MapElements/Map+GeoIspLookup/MapElements/Map+GeoCityLookup/MapElements/Map+DecompressPayload/MapElements/Map+ParseUri/MapWithFailures+WriteErrorOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/CompressPayload/MapElements/Map+WriteErrorOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+WriteErrorOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+WriteErrorOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+LimitPayloadSize/MapWithFailures+WriteErrorOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/CompressPayload/MapElements/Map+WriteErrorOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+WriteErrorOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+WriteErrorOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+ParsePayload/FlatMapElements.FlatMapWithFailures/FlatMapWithFailures+WriteErrorOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/CompressPayload/MapElements/Map+WriteErrorOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+WriteErrorOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+WriteErrorOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+ParseUserAgent/MapElements/Map+NormalizeAttributes/MapElements/Map+AddMetadata/MapWithFailures+WriteErrorOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/CompressPayload/MapElements/Map+WriteErrorOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+WriteErrorOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+WriteErrorOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+Write.BigQueryOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/CompressPayload/MapElements/Map+WriteErrorOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+WriteErrorOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+WriteErrorOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+Write.BigQueryOutput/CompressPayload/MapElements/Map+Write.BigQueryOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/LimitPayloadSize/MapWithFailures+WriteErrorOutput/CompressPayload/MapElements/Map+WriteErrorOutput/KeyByBigQueryTableDestination/MapElements.MapWithFailures/MapWithFailures+WriteErrorOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+WriteErrorOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+WriteErrorOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Session/Flatten+WriteErrorOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Write+Write.BigQueryOutput/BigQueryIO.Write/PrepareWrite/ParDo(Anonymous)+Write.BigQueryOutput/BigQueryIO.Write/BatchLoads/rewindowIntoGlobal/Window.Assign+Write.BigQueryOutput/BigQueryIO.Write/BatchLoads/WriteBundlesToFiles+Write.BigQueryOutput/BigQueryIO.Write/BatchLoads/ReifyResults/View.AsIterable/ParDo(ToIsmRecordForGlobalWindow)+Write.BigQueryOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Reify+Write.BigQueryOutput/BigQueryIO.Write/BatchLoads/GroupByDestination/Write failed., The job failed because a work item has failed 4 times.
```

This was due to many workers having errors like:

```
Error message from worker: java.io.IOException: Failed to advance reader of source: name: "projects/moz-fx-data-backfill-6/locations/us/sessions/CAISDENad29RcnNNaUJBbBoCanEaAml3/streams/CJcHGgJqcRoCaXcgsPnJ5gIoAg"
Caused by: com.google.api.gax.rpc.InternalException: io.grpc.StatusRuntimeException: INTERNAL: RST_STREAM closed stream. HTTP/2 error code: INTERNAL_ERROR
```

The Diagnostics tab on the job shows 542 instances of:

```
I0908 00:14:14.101206 6905 log_monitor.go:160] New status generated: &{Source:kernel-monitor Events:[{Severity:warn Timestamp:2021-09-08 00:13:58.302819954 +0000 UTC m=-15.099678467 Reason:OOMKilling Message:Out of memory: Killed process 336 (chronyd) total-vm:85904kB, anon-rss:180kB, file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:68kB oom_score_adj:0}] Conditions:[{Type:KernelDeadlock Status:False Transition:2021-09-08 00:14:13.642938255 +0000 UTC m=+0.240439886 Reason:KernelHasNoDeadlock Message:kernel has no deadlock} {Type:ReadonlyFilesystem Status:False Transition:2021-09-08 00:14:13.642938407 +0000 UTC m=+0.240439974 Reason:FilesystemIsNotReadOnly Message:Filesystem is not read-only}]}
The worker VM had to shut down one or more processes due to lack of memory.
```

So this could be due to memory pressure, likely due to GCS buffers for the large number of destination tables.

Test of new buffer config:

```
set -exo pipefail

PROJECT="moz-fx-data-backfill-6"
: "${PIPELINE_FAMILY:=telemetry}"
: "${DT:=2021-09-03}"
JOB_NAME="geo-backfill-${PIPELINE_FAMILY}-${DT}"

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
    --bqRowRestriction=\"submission_timestamp BETWEEN '2021-08-25 01:00:00' AND '2021-08-25 01:10:00'\" \
    --bqWriteMethod=file_loads \
    --bqClusteringFields=submission_timestamp \
    --output=${PROJECT}:\${document_namespace}_live.\${document_type}_v\${document_version} \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:payload_bytes_error.${PIPELINE_FAMILY} \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=false \
    --gcsUploadBufferSizeBytes=4194304 \
"

```


### CN seems unaffected

When looking at backfilled records vs. prod, it looks like pings from China
were unaffected by the geo problem. Every other country saw a downturn in
attribution in the prod data except for CN.

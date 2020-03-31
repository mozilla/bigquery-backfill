#!/bin/bash

set -exo pipefail

ingestion_type=${1:?must be one of structured or telemetry}
pattern=${2:-"*"}

PROJECT="moz-fx-data-backfill-30"
JOB_NAME="backfill-${ingestion_type}-stable-from-gcs-errors"
BUCKET=gs://bug-1625560-backfill

## this script assumes it's being run from the ingestion-beam directory
## of the gcp-ingestion repo.

mvn compile exec:java -Dexec.mainClass=com.mozilla.telemetry.Sink -Dexec.args="\
    --runner=Dataflow \
    --jobName=$JOB_NAME \
    --project=$PROJECT  \
    --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202003270223_317d115.tar.gz \
    --inputType=file \
    --inputFileFormat=json \
    --input=${BUCKET}/${ingestion_type}-decoded_bq-sink/error/${pattern}/**.ndjson.gz \
    --outputType=bigquery \
    --bqWriteMethod=file_loads \
    --bqClusteringFields=normalized_channel,sample_id \
    --output=${PROJECT}:\${document_namespace}_stable.\${document_type}_v\${document_version} \
    --outputTableRowFormat=payload \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:payload_bytes_error.${ingestion_type} \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=false \
    --gcsUploadBufferSizeBytes=16777216 \
"
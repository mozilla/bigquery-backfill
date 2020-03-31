#!/bin/bash

set -exo pipefail

max_workers=${MAX_WORKERS:-150}
ingestion_type=${1:?must be one of structured or telemetry}
start_ds=${2:?must be date in YYYY-MM-DD format}
end_ds=${3:-$start_ds}

PROJECT="moz-fx-data-backfill-30"
BUCKET=gs://bug-1625560-backfill

source "${BASH_SOURCE%/*}/utils.sh"

for ds in $(ds_range "$start_ds" "$end_ds"); do
    source="${BUCKET}/${ingestion_type}-decoded_bq-sink/error/${ds}"
    if ! gsutil ls "$source" 2> /dev/null; then
        echo "skipping $ds for $ingestion_type"
        continue
    fi

    job_name="backfill-${ingestion_type}-${ds}-stable-from-gcs-errors"

    mvn compile exec:java -Dexec.mainClass=com.mozilla.telemetry.Sink -Dexec.args="\
        --runner=Dataflow \
        --maxNumWorkers=$max_workers \
        --jobName=$job_name \
        --project=$PROJECT  \
        --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202003270223_317d115.tar.gz \
        --inputType=file \
        --inputFileFormat=json \
        --input=${source}/**.ndjson.gz \
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
done
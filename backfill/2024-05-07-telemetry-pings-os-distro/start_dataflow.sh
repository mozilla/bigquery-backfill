#!/bin/bash

set -exo pipefail

PROJECT="moz-fx-data-backfill-1"
JOB_NAME="telemetry-os-distro-backfill-1"

# this script assumes it's being run from the ingestion-beam directory
# of the gcp-ingestion repo.

mvn compile exec:java -Dexec.mainClass=com.mozilla.telemetry.Decoder -Dmaven.compiler.release=11 -Dexec.args="\
    --runner=Dataflow \
    --jobName=$JOB_NAME \
    --project=$PROJECT  \
    --geoCityDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-City/20240430/GeoIP2-City.mmdb \
    --geoCityFilter=gs://moz-fx-data-prod-dataflow-templates/cities15000.txt \
    --geoIspDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-ISP/20240430/GeoIP2-ISP.mmdb \
    --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202405020245_10116618.tar.gz \
    --inputType=bigquery_table \
    --input='$PROJECT:payload_bytes_error_os_distro.telemetry_input' \
    --bqReadMethod=storageapi \
    --outputType=bigquery \
    --bqWriteMethod=file_loads \
    --bqClusteringFields=normalized_channel,sample_id \
    --output=${PROJECT}:telemetry_os_distro_output.\${document_type}_v\${document_version} \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:payload_bytes_error_os_distro.telemetry \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=false \
    --gcsUploadBufferSizeBytes=16777216 \
    --tempLocation=gs://dataflow-staging-us-central1-215736861657/temp/ \
    --numWorkers=5 \
    --maxNumWorkers=200 \
"

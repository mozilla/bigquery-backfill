#!/bin/bash

set -exo pipefail

PROJECT="moz-fx-data-backfill-1"
JOB_NAME="ads-backend-backfill-deng-10814"

# This script assumes it's being run from the ingestion-beam directory
# of the gcp-ingestion repo, on the branch with the decoder changes from
# https://github.com/mozilla/gcp-ingestion/pull/2913
#
# You may need to run:
#   gcloud auth application-default set-quota-project moz-fx-data-backfill-1

mvn compile exec:java -Dexec.mainClass=com.mozilla.telemetry.Decoder -Dmaven.compiler.release=11 -Dexec.args="\
    --runner=Dataflow \
    --jobName=$JOB_NAME \
    --project=$PROJECT \
    --geoCityDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-City/20260317/GeoIP2-City.mmdb \
    --geoCityFilter=gs://moz-fx-data-prod-dataflow-templates/cities15000.txt \
    --geoIspDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-ISP/20260317/GeoIP2-ISP.mmdb \
    --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202603180207_af5d95d4d.tar.gz \
    --inputType=bigquery_table \
    --input='$PROJECT:payload_bytes_error.backfill' \
    --bqRowRestriction=\"DATE(submission_timestamp) = '2026-03-17'\" \
    --bqReadMethod=storageapi \
    --outputType=bigquery \
    --bqWriteMethod=file_loads \
    --bqClusteringFields=submission_timestamp \
    --output=${PROJECT}:\${document_namespace}_live.\${document_type}_v\${document_version} \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:payload_bytes_error.structured \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=false \
    --gcsUploadBufferSizeBytes=16777216 \
    --tempLocation=gs://dataflow-staging-us-central1-215736861657/temp/ \
    --numWorkers=5 \
    --maxNumWorkers=200 \
"

#!/bin/bash
set -exo pipefail

# This script assumes it's being run from the ingestion-beam directory of the gcp-ingestion repo
# with the code set to current contents of the main branch.

# https://mozilla-hub.atlassian.net/browse/DSRE-999?focusedCommentId=587851
PROJECT="moz-fx-data-backfill-10"
JOB_NAME="decoder"
: "${START_DATE:=2022-08-31}"
: "${END_DATE:=2022-08-31}"

mvn \
  clean \
  compile \
  exec:java -Dexec.mainClass=com.mozilla.telemetry.Decoder -Dexec.args="\
      --runner=Dataflow \
      --jobName=$JOB_NAME \
      --project=$PROJECT \
      --geoCityDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-City/20220830/GeoIP2-City.mmdb \
      --geoIspDatabase=gs://moz-fx-data-prod-geoip/GeoIP2-ISP/20220830/GeoIP2-ISP.mmdb \
      --geoCityFilter=gs://moz-fx-data-prod-dataflow-templates/cities15000.txt \
      --schemasLocation=gs://moz-fx-data-prod-dataflow/schemas/202208310238_cc148147.tar.gz \
      --inputType=bigquery_table \
      --input=\"$PROJECT:payload_bytes_raw.backfill\" \
      --bqReadMethod=storageapi \
      --outputType=bigquery \
      --bqRowRestriction=\"DATE(submission_timestamp) BETWEEN '$START_DATE' AND '$END_DATE'\" \
      --bqWriteMethod=file_loads \
      --bqClusteringFields=submission_timestamp \
      --output=$PROJECT:\${document_namespace}_live.\${document_type}_v\${document_version} \
      --errorOutputType=bigquery \
      --errorOutput=$PROJECT:payload_bytes_error.structured \
      --experiments=shuffle_mode=service \
      --region=us-central1 \
      --usePublicIps=false \
      --gcsUploadBufferSizeBytes=4194304 \
    "

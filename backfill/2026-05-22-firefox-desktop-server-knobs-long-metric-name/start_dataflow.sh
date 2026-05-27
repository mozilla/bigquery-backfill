#!/bin/bash
#
# Run from the `ingestion-beam/` directory in a checkout of gcp-ingestion.
#
# Reads the affected error rows from `moz-fx-data-backfill-1.payload_bytes_error.backfill`
# (populated by the INSERT in README.md step 1), runs them through the Decoder against
# a schemas tarball that includes mozilla-pipeline-schemas#871 (which loosens the
# `ping_info.server_knobs_config.metrics_enabled` validation), and writes the resulting
# valid pings to `firefox_desktop_live.baseline_v1` in the backfill project.
#
# Output uses the templated `${document_type}_v${document_version}` form so that the
# routing matches the production decoder behavior — if any non-`baseline` rows are
# present in the input table, they will route to the correct table rather than mixing.

set -exo pipefail

PROJECT="moz-fx-data-backfill-1"
JOB_NAME="firefox-desktop-server-knobs-long-metric-name-backfill-1"

# Found the latest tarball with:
#   gsutil ls gs://moz-fx-data-prod-dataflow/schemas/ | tail
SCHEMAS_LOCATION="gs://moz-fx-data-prod-dataflow/schemas/202605250235_b7297c1a6.tar.gz"

# Date range of the affected pings. See affected_pings.sql for the empirical bounds.
START_DATE="2026-05-19"
END_DATE="2026-05-20"   # confirmed via affected_pings.sql (zero rejections from 2026-05-21 onward)

# GeoIP databases — use the latest published versions at backfill time.
GEO_CITY_DB="gs://moz-fx-data-prod-geoip/GeoIP2-City/20260521/GeoIP2-City.mmdb"
GEO_ISP_DB="gs://moz-fx-data-prod-geoip/GeoIP2-ISP/20260521/GeoIP2-ISP.mmdb"

mvn compile exec:java \
  -Dexec.mainClass=com.mozilla.telemetry.Decoder \
  -Dmaven.compiler.release=11 \
  -Dexec.args="\
    --runner=Dataflow \
    --jobName=${JOB_NAME} \
    --project=${PROJECT} \
    --geoCityDatabase=${GEO_CITY_DB} \
    --geoCityFilter=gs://moz-fx-data-prod-dataflow-templates/cities15000.txt \
    --geoIspDatabase=${GEO_ISP_DB} \
    --schemasLocation=${SCHEMAS_LOCATION} \
    --inputType=bigquery_table \
    --input=${PROJECT}:payload_bytes_error.backfill \
    --bqRowRestriction=\"DATE(submission_timestamp) BETWEEN '${START_DATE}' AND '${END_DATE}'\" \
    --bqReadMethod=storageapi \
    --outputType=bigquery \
    --bqWriteMethod=file_loads \
    --bqClusteringFields=submission_timestamp \
    --output=${PROJECT}:firefox_desktop_live.\${document_type}_v\${document_version} \
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

#!/bin/bash
#
# Run from the `ingestion-beam/` directory in a checkout of gcp-ingestion.
#
# Reads the affected error rows from `BACKFILL_PROJECT.backfill_input.payload_bytes_error`
# (populated by 02_copy_error_rows.sql), runs them through the Decoder, and writes the
# resulting valid pings to the staging_live tables in the sandbox.
#
# Using the sandbox rather than moz-fx-data-backfill-1 because backfill project access is
# pending. Requires a temp GCS bucket and a service account in the sandbox project.
#
# The decoder build must include gcp-ingestion#2980, which strips client_info and
# ping_info before validation. Without it the old shape pings fail again for the same
# reason they were rejected the first time.
#
# --schemasLocation must point at a tarball containing the glean-min suggest schemas.
#
# NOTE ON GEO: the GeoIP databases are required. Omitting them does not produce null geo,
# it fails the job on the first message with
#   IllegalArgumentException: --geoCityDatabase must be defined for GeoCityLookup!
# Geo and isp are nulled after the prod insert by 03_scrub_geo_isp.sql, in one pass over
# the historical and recovered rows together.
#
# Output uses the ${document_namespace}__${document_type}_v${document_version} form so all
# 15 tables land in one staging dataset rather than needing 8 separate _live datasets.
#
# usePublicIps=true because the sandbox is unlikely to have the VPC config the backfill
# project has. Flip it back if the sandbox does have private networking.

set -exo pipefail

PROJECT="BACKFILL_PROJECT"
JOB_NAME="quick-suggest-ohttp-info-sections-backfill-1"

# Schemas tarball copied from prod into the staging bucket, because the sandbox worker
# service account cannot read gs://moz-fx-data-prod-dataflow.
#   gsutil ls gs://moz-fx-data-prod-dataflow/schemas/ | tail
#   gsutil cp gs://moz-fx-data-prod-dataflow/schemas/<tarball> gs://BACKFILL_STAGING_BUCKET/schemas/
SCHEMAS_LOCATION="gs://BACKFILL_STAGING_BUCKET/schemas/202609230019_cce811720.tar.gz"

# Cutover window. Confirm with 01_affected_pings.sql that counts fall away outside it.
START_DATE="2026-09-22"
END_DATE="2026-09-23"

# GeoIP: these are the TEST fixtures from gcp-ingestion, copied into the staging bucket,
# not the real databases.
#
# Two reasons that is fine here. The prod geoip bucket is not reachable from the sandbox,
# and GeoCityLookup.apply returns early when a message already carries a geo_country
# attribute, which every row reprocessed from payload_bytes_error does. So the databases
# are loaded at startup but never consulted for our messages. Any geo that does slip
# through is nulled by 08_scrub_geo_isp.sql regardless.
#
# --geoCityFilter is omitted deliberately. It is optional (GeoCityLookup only loads it
# when non-empty), it lives in another unreachable prod bucket, and with the lookup
# skipped there is nothing for it to filter.
GEO_CITY_DB="gs://BACKFILL_STAGING_BUCKET/geoip/GeoIP2-City-Test.mmdb"
GEO_ISP_DB="gs://BACKFILL_STAGING_BUCKET/geoip/GeoIP2-ISP-Test.mmdb"

mvn compile exec:java \
  -Dexec.mainClass=com.mozilla.telemetry.Decoder \
  -Dmaven.compiler.release=11 \
  -Dexec.args="\
    --runner=Dataflow \
    --jobName=${JOB_NAME} \
    --project=${PROJECT} \
    --geoCityDatabase=${GEO_CITY_DB} \
    --geoIspDatabase=${GEO_ISP_DB} \
    --schemasLocation=${SCHEMAS_LOCATION} \
    --inputType=bigquery_table \
    --input=${PROJECT}:backfill_input.payload_bytes_error \
    --bqRowRestriction=\"DATE(submission_timestamp) BETWEEN '${START_DATE}' AND '${END_DATE}'\" \
    --bqReadMethod=storageapi \
    --outputType=bigquery \
    --bqWriteMethod=file_loads \
    --bqClusteringFields=submission_timestamp \
    --output=${PROJECT}:staging_live.\${document_namespace}__\${document_type}_v\${document_version} \
    --errorOutputType=bigquery \
    --errorOutput=${PROJECT}:backfill_input.decoder_errors \
    --experiments=shuffle_mode=service \
    --region=us-central1 \
    --usePublicIps=true \
    --gcsUploadBufferSizeBytes=16777216 \
    --tempLocation=gs://BACKFILL_STAGING_BUCKET/temp/ \
    --numWorkers=5 \
    --maxNumWorkers=200 \
  "

#!/bin/bash

set -e

PROJECT=moz-fx-data-backfill-1

# Create staging datasets and tables, copying schemas from stable tables
# telemetry_os_distro_output is for the dataflow output, telemetry_os_distro_deduped is the deduped output

src_table=moz-fx-data-shared-prod:firefox_desktop_stable.metrics_v1
output_dataset=firefox_desktop_metrics_output
deduped_dataset=firefox_desktop_metrics_deduped

bq mk $PROJECT:$output_dataset
bq mk $PROJECT:$deduped_dataset

bq show --format=json $src_table | jq '.schema.fields' > table.json
bq mk -t \
   --time_partitioning_field=submission_timestamp \
   --clustering_fields=normalized_channel,sample_id \
   --table "$PROJECT:$output_dataset.$table" \
   table.json

# Create an error table for dataflow

pbr_dataset=payload_bytes_error_firefox_desktop_metrics

bq mk $PROJECT:$pbr_dataset

bq show --format=json "moz-fx-data-shared-prod:payload_bytes_error.structured" | jq '.schema.fields' > table.json
bq mk -t \
   --time_partitioning_field=submission_timestamp \
   --clustering_fields=submission_timestamp \
   --table "$PROJECT:$pbr_dataset.structured" \
   table.json

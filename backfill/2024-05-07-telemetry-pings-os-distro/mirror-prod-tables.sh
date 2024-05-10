#!/bin/bash

set -e

PROJECT=moz-fx-data-backfill-1

# Create staging datasets and tables, copying schemas from stable tables
# telemetry_os_distro_output is for the dataflow output, telemetry_os_distro_deduped is the deduped output

src_dataset=telemetry_stable
output_dataset=telemetry_os_distro_output
deduped_dataset=telemetry_os_distro_deduped

bq mk $PROJECT:$output_dataset
bq mk $PROJECT:$deduped_dataset

# use bq mk instead of CREATE TABLE LIKE because some tables we need have restricted read access, e.g. main_v4
# we don't need these tables but this is easier than hardcoding the ones we need since doctype to table isn't 1:1
# also to not have partition filter requirement
for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod "$src_dataset" | tail -n+3 | awk '{print $1}' | grep -E '_v'); do
  bq show --format=json "moz-fx-data-shared-prod:$src_dataset.$table" | jq '.schema.fields' > table.json
  bq mk -t \
     --time_partitioning_field=submission_timestamp \
     --clustering_fields=normalized_channel,sample_id \
     --table "$PROJECT:$output_dataset.$table" \
     table.json
done

# Create an error table for dataflow

pbr_dataset=payload_bytes_error_os_distro

bq mk $PROJECT:$pbr_dataset

bq show --format=json "moz-fx-data-shared-prod:payload_bytes_error.telemetry" | jq '.schema.fields' > table.json
bq mk -t \
   --time_partitioning_field=submission_timestamp \
   --clustering_fields=submission_timestamp \
   --table "$PROJECT:$pbr_dataset.telemetry" \
   table.json

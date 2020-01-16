#!/bin/bash

# Copies the structure of prod tables into a project where you'll be backfilling.
# BEWARE: This script by default deletes existing tables!

# You likely want to make a copy of this and modify to suit, deleting some of the blocks,
# adding `grep` invocations to limit which tables you create, etc.

# Set this to a desired destination project that you'll be backfilling into
PROJECT=moz-fx-data-backfill-?

# Copy stable table schemas
for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep 'telemetry_stable'); do
    bq mk $PROJECT:$dataset
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod $dataset | tail -n+3 | awk '{print $1}' | grep -E 'crash_v4'); do
        bq rm -f $PROJECT:$dataset.$table
        bq mk -t \
           --time_partitioning_field=submission_timestamp \
           --clustering_fields=normalized_channel,sample_id \
           --schema <(bq show --format=json moz-fx-data-shared-prod:$dataset.$table | jq '.schema.fields') \
           $PROJECT:$dataset.$table
    done
done

# Copy payload_bytes_error tables schemas
for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep 'payload_bytes_error'); do
    bq mk $PROJECT:$dataset
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod $dataset | tail -n+3 | awk '{print $1}'); do
        bq rm -f $PROJECT:$dataset.$table
        bq mk -t \
           --time_partitioning_field=submission_timestamp \
           --clustering_fields=submission_timestamp \
           --schema <(bq show --format=json moz-fx-data-shared-prod:$dataset.$table | jq '.schema.fields') \
           $PROJECT:$dataset.$table
    done
done

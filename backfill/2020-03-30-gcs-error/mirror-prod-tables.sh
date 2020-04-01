#!/bin/bash

PROJECT=${1:-moz-fx-data-backfill-30}
RESET=${RESET:-false}

set -x

for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep 'payload_bytes_error'); do
    bq mk $PROJECT:$dataset
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod $dataset | grep TABLE | awk '{print $1}'); do
        if $RESET; then
            bq rm -f $PROJECT:$dataset.$table
        fi
        bq mk -t \
           --time_partitioning_field=submission_timestamp \
           --clustering_fields=submission_timestamp \
           --schema <(bq show --format=json moz-fx-data-shared-prod:$dataset.$table | jq '.schema.fields') \
           $PROJECT:$dataset.$table
    done
done

for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep '_stable'); do
    bq mk $PROJECT:$dataset
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod $dataset | grep TABLE | awk '{print $1}'); do
        if $RESET; then
            bq rm -f $PROJECT:$dataset.$table
        fi
        bq mk -t \
           --time_partitioning_field=submission_timestamp \
           --clustering_fields=normalized_channel,sample_id \
           --schema <(bq show --format=json moz-fx-data-shared-prod:$dataset.$table | jq '.schema.fields') \
           $PROJECT:$dataset.$table
    done
done

#!/bin/bash

PROJECT=moz-fx-data-backfill-31

for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep '_stable'); do
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod "$dataset" | grep TABLE | awk '{print $1}'); do
        echo "copying $dataset.$table from $PROJECT into moz-fx-data-shared-prod"
        src="${PROJECT}:${dataset}.${table}"
        dst="moz-fx-data-shared-prod:${dataset}.${table}"
        bq cp --no_clobber --append_table "$src" "$dst"
    done
done

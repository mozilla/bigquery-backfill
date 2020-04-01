#!/bin/bash

# be warned, this will start removing all datasets in the project once started
projects="moz-fx-data-backfill-30 moz-fx-data-backfill-31"

for project in $projects; do
    datasets=$(
        bq ls --project_id $project --format json | \
        jq -r ".[] | .datasetReference.datasetId"
    )
    for dataset in $datasets; do
        set -x
        bq rm -r -f --project_id $project $dataset
        set +x
    done
done
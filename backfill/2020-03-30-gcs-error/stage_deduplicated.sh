#!/bin/bash

SRC_PROJECT=moz-fx-data-backfill-30
DST_PROJECT=moz-fx-data-backfill-30

set -x

function make_query {
    local dataset=$1 
    local table=$2 
    local start_ds=$3
    local end_ds=$4
    cat << EOF
WITH seen_documents AS (
    SELECT DISTINCT
        document_id
    FROM
        \`moz-fx-data-shared-prod\`.${dataset}.${table}
    WHERE
        date(submission_date) >= "${start_ds}"
        AND date(submission_date) <= "${end_ds}"
),
-- filter out documents that have already been processed
filtered_errors AS (
    SELECT
        *
    FROM
        \`${SRC_PROJECT}\`.${dataset}.${table}
    LEFT OUTER JOIN
        seen_documents
    USING
        (document_id)
    WHERE
        seen_documents.document_id IS NULL
),
-- https://github.com/mozilla/bigquery-etl/blob/master/script/copy_deduplicate
numbered_duplicates AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION_BY document_id) AS _n
    FROM
        filtered_errors
)
SELECT
    * EXCEPT(_n)
FROM
    numbered_duplicates
WHERE
    _n = 1
EOF
}

for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep '_stable'); do
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod "$dataset" | grep TABLE | awk '{print $1}'); do
        tmp=$(mktemp)
        make_query "$dataset" "$table" "2020-02-18" "2020-03-14" > "$tmp"
        cat $tmp
        bq query \
            --nouse_legacy_sql \
            --project_id "$SRC_PROJECT" \
            --dataset_id "$dataset" \
            --destination_table "${DST_PROJECT}:${dataset}.${table}" \
            --replace_table \
            --max_rows 0 \
            < "$tmp"
    done
done

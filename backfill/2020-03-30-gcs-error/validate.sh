#!/bin/bash

SRC_PROJECT=moz-fx-data-backfill-30
DST_PROJECT=moz-fx-data-backfill-31
DEBUG=${DEBUG:=false}


function make_query {
    local dataset=$1
    local table=$2
    cat << EOF
WITH raw_errors AS (
    SELECT
        date(submission_timestamp) as submission_date,
        count(distinct document_id) as num_raw
    FROM
        \`${SRC_PROJECT}\`.${dataset}.${table}
    WHERE
        date(submission_timestamp) >= "2020-02-18"
    GROUP BY
        1
),
deduplicated_errors AS (
    SELECT
        date(submission_timestamp) as submission_date,
        count(distinct document_id) as num_deduped
    FROM
        \`${DST_PROJECT}\`.${dataset}.${table}
    WHERE
        date(submission_timestamp) >= "2020-02-18"
    GROUP BY
        1
),
joined_errors AS (
    SELECT
        *,
        (num_raw - num_deduped) as diff
    FROM
        raw_errors
    FULL JOIN
        deduplicated_errors
    USING
        (submission_date)
)
SELECT
    current_timestamp() as query_timestamp,
    '${dataset}' as dataset,
    '${table}' as table,
    *
FROM
    joined_errors
EOF
}

if $DEBUG; then
    make_query "activity_stream_stable" "events_v1"
fi

if ! bq ls "${SRC_PROJECT}:validation" 2> /dev/null; then
    bq mk "${SRC_PROJECT}:validation"
fi

for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep '_stable'); do
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod "$dataset" | grep TABLE | awk '{print $1}'); do
        tmp=$(mktemp)
        make_query "$dataset" "$table" > "$tmp"
        echo "running validation for $dataset.$table for $SRC_PROJECT and $DST_PROJECT"
        bq query \
            $(if $DEBUG; then echo "--dry_run"; fi) \
            --nouse_legacy_sql \
            --project_id "$SRC_PROJECT" \
            --dataset_id "$dataset" \
            --destination_table "${SRC_PROJECT}:validation.table_counts" \
            --append_table \
            --max_rows 0 \
            < "$tmp"
    done
done

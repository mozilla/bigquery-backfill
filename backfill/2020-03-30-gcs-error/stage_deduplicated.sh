#!/bin/bash

SRC_PROJECT=moz-fx-data-backfill-30
DST_PROJECT=moz-fx-data-backfill-31
DEBUG=${DEBUG:=false}

# xargs usage: https://unix.stackexchange.com/a/65225
dates=$(
    gsutil ls "gs://bug-1625560-backfill/*/error/" | \
    xargs -L1 sh -c 'basename $1' dummy | \
    grep -v ":" | \
    sort | \
    uniq
)

function format_dates {
    DATES="$1" python3 - << EOF
from os import environ
dates = environ.get("DATES").split()
print(",".join(f"'{ds}'" for ds in dates))
EOF
}

function make_query {
    local dataset=$1 
    local table=$2
    cat << EOF
WITH seen_documents AS (
    SELECT DISTINCT
        date(submission_timestamp) as submission_date,
        document_id
    FROM
        \`moz-fx-data-shared-prod\`.${dataset}.${table}
    WHERE
        date(submission_timestamp) in ($(format_dates "$dates"))
),
-- filter out documents that have already been processed
filtered_errors AS (
    SELECT
        * EXCEPT(document_id),
        t1.document_id
    FROM
        \`${SRC_PROJECT}\`.${dataset}.${table} t1
    LEFT OUTER JOIN
        seen_documents t2
    ON
        t1.document_id = t2.document_id
        AND date(t1.submission_timestamp) = t2.submission_date
    WHERE
        t2.document_id IS NULL
),
-- https://github.com/mozilla/bigquery-etl/blob/master/script/copy_deduplicate
numbered_duplicates AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY document_id, submission_date
            ORDER BY submission_timestamp
        ) AS _n
    FROM
        filtered_errors
)
SELECT
    * EXCEPT(_n, submission_date)
FROM
    numbered_duplicates
WHERE
    _n = 1
EOF
}

if $DEBUG; then
    make_query "activity_stream_stable" "events_v1"
fi

logs=$(mktemp)

for dataset in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod | grep '_stable'); do
    for table in $(bq ls -n 1000 --project_id=moz-fx-data-shared-prod "$dataset" | grep TABLE | awk '{print $1}'); do
        tmp=$(mktemp)
        make_query "$dataset" "$table" > "$tmp"
        echo "running deduplication for $dataset.$table from $SRC_PROJECT into $DST_PROJECT" | tee -a "$logs"
        bq query \
            $(if $DEBUG; then echo "--dry_run"; fi) \
            --nouse_legacy_sql \
            --project_id "$SRC_PROJECT" \
            --dataset_id "$dataset" \
            --destination_table "${DST_PROJECT}:${dataset}.${table}" \
            --replace \
            --max_rows 0 \
            < "$tmp" | tee -a "$logs"
    done
done

if $DEBUG; then
    out="stage_deduplicate.logs"
    cat "$out" | \
        grep Query | tr -dc '0-9\n' | \
        awk '{ sum += $1; } END { print "expect to scan " sum/1e12 " TB" }'

    cp "$logs" "$out"
fi

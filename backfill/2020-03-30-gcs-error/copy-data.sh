#!/bin/bash
set +x

PROJECT=moz-fx-data-backfill-30
BUCKET=gs://bug-1625560-backfill

source "${BASH_SOURCE%/*}/utils.sh"

# set project to the correct id
original_project=$(gcloud config get-value project)
function cleanup {
    gcloud config set project "$original_project"
}
trap cleanup EXIT
gcloud config set project $PROJECT

# create the bucket if it doesn't exist
if ! gsutil ls $BUCKET 2> /dev/null; then
    gsutil mb $BUCKET
fi

# copy the data from the right ranges
source_bucket=gs://moz-fx-data-prod-data
prefix=structured-decoded_bq-sink/error
for ds in $(ds_range "2020-02-18" "2020-03-14"); do
    gsutil -m cp -r $source_bucket/$prefix/$ds/ $BUCKET/$prefix/
done

source_bucket=gs://moz-fx-data-prod-data
prefix=telemetry-decoded_bq-sink/error
for ds in $(ds_range "2020-02-19" "2020-03-12"); do
    gsutil -m cp -r $source_bucket/$prefix/$ds/ $BUCKET/$prefix/
done
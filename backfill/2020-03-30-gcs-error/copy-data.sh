#!/bin/bash
set +x

PROJECT=moz-fx-data-backfill-30
BUCKET=gs://bug-1625560-backfill

# cross-platform date range
function ds_range {
    DS_START=$1 DS_END=$2 python3 - <<EOD
from datetime import date, timedelta, datetime
from os import environ
def parse(ds):
    return datetime.strptime(ds, "%Y-%m-%d")
start_date = parse(environ["DS_START"])
end_date = parse(environ["DS_END"])
dates = []
for i in range((end_date - start_date).days):
    dt = start_date + timedelta(i)
    dates.append(dt.strftime("%Y-%m-%d"))
print("\n".join(dates))
EOD
}

# set project to the correct id
original_project=$(gcloud config get-value project)
function cleanup {
    gcloud config set project "$original_project"
}
trap cleanup EXIT
gcloud config set project $PROJECT

# create the bucket if it doesn't exist
if ! gsutil ls $BUCKET; then
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
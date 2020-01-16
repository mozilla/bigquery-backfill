# bigquery-backfill
Scripts and historical records related to backfills in Mozilla's telemetry pipeline

## Layout

There is a `script` directory containing relatively pristine reference scripts
that you can copy and paste into a new backfill scenario and modify for your
particular needs.

There is a `backfills` directory where each subdirectory should be a dated
backfill event, containing all the scripts used and a description of the
overall scenario.

## Setup

Most of these backfill scenarios will assume that you have
[`gcp-ingestion`](https://github.com/mozilla/gcp-ingestion) checked out
locally. `mvn` invocations in scripts likely assume that you're in the
`ingestion-beam` directory of that repo.

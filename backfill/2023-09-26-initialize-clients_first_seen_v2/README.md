# Initialize table telemetry_derived.clients_first_seen_v2

  - [DS-2948](https://mozilla-hub.atlassian.net/browse/DS-2948/): Redefining Desktop first_seen_date and New Profiles
  - GCP project used:  `moz-fx-data-shared-prod.telemetry_derived`

## Context

  - The table telemetry_derived.clients_first_seen_v2 redefines the first_seen_date for Desktop clients by querying 3 pings: main, new_profile and first_shutdown.
  - Given the size of the data, it's required to initialize in parallel using a bigquery-etl function and a query that are both suceptible to change due to ongoing updates to the code.
  - Therefore, the decision is to initialize the table with the current state of bigquery-etl and the query in this PR.


## Step 1: Run from repository [bigquery-etl](https://github.com/mozilla/bigquery-etl)

- git checkout branch DS-3054_support_running_initialization_query_in_parallel

- If the branch is not available, update the repository for files:
- bigquery_etl/cli/query.py
- sql/moz-fx-data-shared-prod/telemetry_derived/clients_first_seen_v2/query.sql

## Step 2: Deploy the schema

This table is part of the dry-run skip, so it requires the schema to be deployed manually
`./bqetl query schema deploy --force --ignore-dryrun-skip telemetry_derived.clients_first_seen_v2`

## Step 3: Run command to initialize

`./bqetl query initialize sql/moz-fx-data-shared-prod/telemetry_derived/clients_first_seen_v2/query.sql`

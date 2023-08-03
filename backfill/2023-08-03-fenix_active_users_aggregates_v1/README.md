# Backfill fenix active users aggregates between 2021-01-01 and 2023-08-02

  - [DENG-2998](https://mozilla-hub.atlassian.net/browse/DS-2998): Add attribution data to active users aggregates
  - GCP project used:  `moz-fx-data-shared-prod.analysis`


## Context

AS per DENG-2998 it was decided to add attribution data to active users aggregates table. However, the traditional backfill via airflow would affect the aua numbers due to shredder's impact. Hence it was decided to leverage `unified metrics` (which is not impacted by shredder)
to populate temporary active users aggregates table `fenix_aua_with_att_historical_2021-01-01_2023-08-02` and swap the `fenix_derived.active_users_aggregates_v1` with the temp table.

## Step 1:  Populate  `fenix_aua_with_att_historical_2021-01-01_2023-08-02` using the `query.sql`

## Step 3:  Validate that both tables are exact match.

## Step 2: Take snapshot of `fenix_derived.active_users_aggregates_v1` (set to expire after a month)

## Step 4: Drop `fenix_derived.active_users_aggregates_v1` and rename `fenix_aua_with_att_historical_2021-01-01_2023-08-02` to `fenix_derived.active_users_aggregates_v1` might need SRE support.

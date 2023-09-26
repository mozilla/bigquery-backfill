# Backfill firefox ios active users aggregates between 2021-01-01 and 2023-08-02

  - [DENG-2998](https://mozilla-hub.atlassian.net/browse/DS-2998): Add attribution data to active users aggregates
  - GCP project used:  `moz-fx-data-shared-prod.analysis`


## Context

AS per DENG-2998 it was decided to add attribution data to active users aggregates table. However, the traditional backfill via airflow would affect the aua numbers due to shredder's impact. Hence it was decided to leverage `unified metrics` (which is not impacted by shredder)
to populate temporary active users aggregates table `firefox_ios_aua_with_att_historical` and swap the `firefox_ios.active_users_aggregates_v1` with the temp table.

## Step 1:  Populate  `firefox_ios_aua_with_att_historical` using the  `query.sql`

## Step 2:  Validate that both tables are exact match.

## Step 3: Take snapshot of `firefox_ios.active_users_aggregates_v1` (set to expire after a month) or alternatively bump the version of the table which requires minimal/ no intervention from DSRE


## Step 4: Rename `firefox_ios_aua_with_att_historical` to `firefox_ios.active_users_aggregates_v1` might need SRE support and deprecate `firefox_ios.active_users_aggregates_v1`

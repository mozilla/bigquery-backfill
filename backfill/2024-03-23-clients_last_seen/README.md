# Backfill clients_last_seen tables for Mobile and Desktop from the start date.

- [DENG-2975](https://mozilla-hub.atlassian.net/browse/DENG-2975)
## Context
The definition of DAU is updated and implemented in the clients_last_seen and baseline_clients_last_seen_tables
which requires a full backfill, given that these tables depend on past state.
As part of the backfill new checks are added for automated validation of results, also included in this code.

A GCP VM has been setup for some of these backfills.

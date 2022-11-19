# backfill sponsored tiles and suggest tables

This is an after-the-fact record of backfills of 4 tables:
* `contextual_services_derived.event_aggregates_spons_tiles_v1`
* `telemetry_derived.sponsored_tiles_clients_daily_v1`
* `contextual_services_derived.event_aggregates_suggest_v1`
* `telemetry_derived.suggest_clients_daily_v1`

These backfills are part of a process to revamp the contextual services derived
datasets -- see
[JIRA ticket](https://mozilla-hub.atlassian.net/browse/ADPRODUCTS-367)

See also these PRs for the SQL that was added and changes that were made:

* Sponsored Tiles: [#3203](https://github.com/mozilla/bigquery-etl/pull/3203) [#3338](https://github.com/mozilla/bigquery-etl/pull/3338) [#3355](https://github.com/mozilla/bigquery-etl/pull/3355) [#3341](https://github.com/mozilla/bigquery-etl/pull/3341)
* Suggest: [#3196](https://github.com/mozilla/bigquery-etl/pull/3196) [#3198](https://github.com/mozilla/bigquery-etl/pull/3198) [#3340](https://github.com/mozilla/bigquery-etl/pull/3340) [#3342](https://github.com/mozilla/bigquery-etl/pull/3342)

All backfills were run with the `bqetl` backfill command:
```
./bqetl query backfill --project_id=moz-fx-data-shared-prod \
    --start_date=[...] --end-date=[...] [dataset].[table]
```

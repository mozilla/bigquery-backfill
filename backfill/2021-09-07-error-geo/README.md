# Reprocess from payload_bytes_raw due to incorrect IP lookup

See https://bugzilla.mozilla.org/show_bug.cgi?id=1729069

Last time we needed to reprocess geo was
https://github.com/mozilla/bigquery-backfill/tree/main/backfill/2020-02-07-error-geo


## Initial test

```
gcloud auth application-default login
```



## Gotchas

Permissions issues when trying to set up tables in the backfill project:

```
+ bq query --nouse_legacy_sql 'CREATE OR REPLACE TABLE `moz-fx-data-backfill-6.contextual_services_live.quicksuggest_click_v1` LIKE `moz-fx-data-shared-prod.contextual_services_live.quicksuggest_click_v1`'
BigQuery error in query operation: Error processing job 'moz-fx-data-shared-prod:bqjob_r6228d0d1b75d8b59_0000017bc16718cb_1': Access
Denied: Table moz-fx-data-shared-prod:contextual_services_live.quicksuggest_click_v1: User does not have permission to query table
moz-fx-data-shared-prod:contextual_services_live.quicksuggest_click_v1.
```

My own user can't access the contextual_services tables, or the regrets_reporter table in telemetry.

Also, permissions on the destination live tables in the backfill project are going to allow viewing by all data eng, even the ones that should be more locked down. That's another area where we'll need to think critically and improve backfill processes.


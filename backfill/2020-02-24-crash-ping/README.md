# Backfilling missing fields in crash pings

See https://bugzilla.mozilla.org/show_bug.cgi?id=1617630

There were two fields that we wanted to add which existed only in `additional_properties`. The crash dataset is relatively small, so in
this case we can just do a single backfill into a temporary destination
table inside our backfill project.

```
bq query --append_table \
    --nouse_legacy_sql \
    --project_id 'moz-fx-data-backfill-1' \
    --dataset_id crash_backfill \
    --destination_table 'crash_stable_with_oom_and_moz_crash_reason_feb2020' < \
    crash_v4_with_missing_fields.sql
```
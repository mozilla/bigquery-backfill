# Backfilling missing fields in crash pings

See https://bugzilla.mozilla.org/show_bug.cgi?id=1617630

There were two fields that we wanted to add which existed only in `additional_properties`. The crash dataset is relatively small, so in this case we can just do a single backfill into a temporary destination table inside our backfill project.

```bash
bq query --append_table \
    --nouse_legacy_sql \
    --project_id 'moz-fx-data-backfill-1' \
    --dataset_id crash_backfill \
    --destination_table 'crash_stable_with_oom_and_moz_crash_reason_feb2020' < \
    crash_v4_with_missing_fields.sql
```

Then, we modify the partioning and clustering to match that of the production table:

```sql
CREATE TABLE
  `moz-fx-data-backfill-1.crash_backfill.crash_stable_with_oom_and_moz_crash_reason_feb2020_clustered`
PARTITION BY
  DATE(submission_timestamp)
CLUSTER BY
  normalized_channel,
  sample_id AS
SELECT
  *
FROM
  `moz-fx-data-backfill-1.crash_backfill.crash_stable_with_oom_and_moz_crash_reason_feb2020`
```

Now that the table structure is exactly aligned, we can copy all the partitions into place nearly instantaneously, replacing the existing content. The following runs the copy operations 20 at a time (-P20) and completed in under 1 minute:

```bash
seq 0 166 | xargs -I@ gdate -d '2019-06-01 + @ day' +%F | xargs -P20 -n1 bash -c 'set -ex; echo Processing $1; bq cp -f moz-fx-data-backfill-1:crash_backfill.crash_stable_with_oom_and_moz_crash_reason_feb2020_clustered\$${1//-} moz-fx-data-shared-prod:telemetry_stable.crash_v4\$${1//-} ' -s
```

Finally, we clean up our temporary table. Since there are no GCS resources involved, we can just delete the temporary dataset and be done with it:

```bash
bq rm -r moz-fx-data-backfill-1:crash_backfill
```

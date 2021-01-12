# Backfilling telemetry pings due to `#/environment/system/gfx/adapters/N/GPUActive`

See https://bugzilla.mozilla.org/show_bug.cgi?id=1661565

## Steps

We ran the backfill in the `moz-fx-data-backfill-7` project.

First, we determine the backfill range by querying the relevant error table:

```sql
SELECT
  DATE(submission_timestamp) AS dt,
  COUNT(*)
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  submission_timestamp < '2020-08-21'
  AND submission_timestamp > '2020-07-03'
  AND exception_class = 'org.everit.json.schema.ValidationException'
  AND error_message LIKE '%GPUActive%'
GROUP BY
  1
ORDER BY
  1
```

That showed the affected range as `2020-07-04` through `2020-08-20`.

The following tables are affected:

```
crash
dnssec-study-v1
event
first-shutdown
heartbeat
main
modules
new-profile
update
voice
```

Next, we create destination tables via the `mirror-prod-tables` script and
we populate the `backfill_input` table via query:

```sql
SELECT
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) BETWEEN "2020-07-04"
  AND "2020-08-20"
  AND exception_class = 'org.everit.json.schema.ValidationException'
  AND error_message LIKE '%GPUActive%'
```

Attempting to filter client ids using `udf_js.gunzip` may cause issues with 
exceeding the call stack. We avoid filtering on deletion requests until later.

Next, we construct a suitable Dataflow job configuration in
`launch-dataflow-gpu-active` and run the script.

It may be useful to do a quick run with a subset of data in order to make
sure the scripts are all properly configured by writing a subset of the backfill
input to a table and then running the script on the subset. An important thing to
remember to do is to delete the data written in the test; clean up can be done
by rerunning the `mirror-prod-tables` script.

```sql
SELECT
  *
FROM7.payload_bytes_error.backfill_input`
LIMIT
  1000
```

We visit the GCP console, choose the `moz-fx-data-backfill-7` project
and go to the Dataflow section to watch the progress of the job.
It took about 31 minutes to run to completion.

We validate the results by checking counts per day:

```sql
SELECT
  DATE(submission_timestamp),
  COUNT(*)
FROM
  telemetry_live.main_v4
GROUP BY
  1
ORDER BY
  1
```

We can then run copy_deduplicate (in the bigquery repo) for the tables in the
backfill project. Be sure to change the default project for queries to run in
the correct project.

```bash
gcloud config set project moz-fx-data-backfill-7

# calculate the date range in this ugly one liner
dates=$(python3 -c 'from datetime import datetime as dt, timedelta; \
  start=dt.fromisoformat("2020-07-04"); \
  end=dt.fromisoformat("2020-08-21"); \
  days=(end-start).days; \
  print(" ".join([(start + timedelta(i)).isoformat()[:10] for i in range(days)]))')

# NOTE: prune tables in the live dataset for efficiency, see note below
./script/copy_deduplicate --project-id moz-fx-data-backfill-7 --dates $(echo $dates)
```

This query was slow (hours) because it required iterating over every table in
the project for a period of ~50 days. In the future, it is advisable to prune
all of the unnecessary tables before running the script. Before running
shredder, we'll delete all of the empty stable tables.

```bash
./prune-empty-tables
```

Now we run shredder from the bigquery-etl root.

```bash
script/shredder_delete \
  --billing-projects moz-fx-data-backfill-7 \
  --source-project moz-fx-data-shared-prod \
  --target-project moz-fx-data-backfill-7 \
  --start_date 2020-06-01 \
  --only 'telemetry_stable.*' \
  --dry_run
```

This removes relevant rows from our final tables.

```bash
INFO:root:Scanned 515495784 bytes and deleted 1280 rows from moz-fx-data-backfill-7.telemetry_stable.crash_v4
INFO:root:Scanned 35301644397 bytes and deleted 45159 rows from moz-fx-data-backfill-7.telemetry_stable.event_v4
INFO:root:Scanned 1059770786 bytes and deleted 169 rows from moz-fx-data-backfill-7.telemetry_stable.first_shutdown_v4
INFO:root:Scanned 286322673 bytes and deleted 2 rows from moz-fx-data-backfill-7.telemetry_stable.heartbeat_v4
INFO:root:Scanned 134028021311 bytes and deleted 13872 rows from moz-fx-data-backfill-7.telemetry_stable.main_v4
INFO:root:Scanned 2795691020 bytes and deleted 1071 rows from moz-fx-data-backfill-7.telemetry_stable.modules_v4
INFO:root:Scanned 302643221 bytes and deleted 163 rows from moz-fx-data-backfill-7.telemetry_stable.new_profile_v4
INFO:root:Scanned 1245911143 bytes and deleted 6477 rows from moz-fx-data-backfill-7.telemetry_stable.update_v4
INFO:root:Scanned 286924248 bytes and deleted 10 rows from moz-fx-data-backfill-7.telemetry_stable.voice_v4
INFO:root:Scanned 175822424583 and deleted 68203 rows in total
```

We will need append these results to each of the shared prod stable tables
(requires ops-level permissions). Except, we actually can't run these commands
because the clustering definition in the stable tables was incorrect. We'll
appropriate a new backfill project (`moz-fx-data-backfill-8`) with stable tables
that are defined correctly and proceed from there.

```bash
./mirror-backfill-stable-tables
```

Now perform the backfill:

```bash
# generate the commands to be run
bq ls --format json --project_id=moz-fx-data-backfill-8 telemetry_stable | \
  jq -r '.[] | .tableReference.tableId' | \
  xargs -I{} echo bq cp --append_table \
    moz-fx-data-backfill-8:telemetry_stable.{} \
    moz-fx-data-shared-prod:telemetry_stable.{}
```

```bash
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.crash_v4 moz-fx-data-shared-prod:telemetry_stable.crash_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.dnssec_study_v1_v4 moz-fx-data-shared-prod:telemetry_stable.dnssec_study_v1_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.event_v4 moz-fx-data-shared-prod:telemetry_stable.event_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.first_shutdown_v4 moz-fx-data-shared-prod:telemetry_stable.first_shutdown_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.heartbeat_v4 moz-fx-data-shared-prod:telemetry_stable.heartbeat_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.main_v4 moz-fx-data-shared-prod:telemetry_stable.main_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.modules_v4 moz-fx-data-shared-prod:telemetry_stable.modules_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.new_profile_v4 moz-fx-data-shared-prod:telemetry_stable.new_profile_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.update_v4 moz-fx-data-shared-prod:telemetry_stable.update_v4
bq cp --append_table moz-fx-data-backfill-8:telemetry_stable.voice_v4 moz-fx-data-shared-prod:telemetry_stable.voice_v4
```

Now stable tables are backfilled, so we can delete the rows in the error table
corresponding to the backfilled pings from the `backfill-7` project.

```sql
DELETE
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) BETWEEN "2020-07-04"
  AND "2020-08-20"
  AND exception_class = 'org.everit.json.schema.ValidationException'
  AND error_message LIKE '%GPUActive%'
```

We also need to update the error table with any errors that occurred during
the backfill (requires ops-level permissions):

```
bq cp --append_table \
  moz-fx-data-backfill-7:payload_bytes_error.telemetry \
  moz-fx-data-shared-prod:payload_bytes_error.telemetry
```

# Backfilling crash pings due to minidumpSha256Hash field

In late December 2019, we merged a change to the crash ping schema that
added a required `minidumpSha256Hash` field that turned out to be not
always present. We dropped the `required` part and then needed to backfill
the rejected pings.

## Steps

We ran the backfill in the `moz-fx-data-backfill-2` project. 

First, we determine the backfill range by querying the relevant error table:

```
SELECT
  date(submission_timestamp) as dt, count(*)
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) >= "2019-12-01"
  AND document_type = 'crash'
  AND error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/minidumpSha256Hash%'
  group by 1 order by 1
```

That showed the affected range as `2019-12-20` through `2020-01-08`.

Next, we create destination tables via the `mirror-prod-tables` script.

Next, we construct a suitable Dataflow job configuration in
`launch-dataflow-minidump` and run the script.

We visit the GCP console, choose the `moz-fx-data-backfill-2` project
and go to the Dataflow section to watch the progress of the job.
It took about 45 minutes to run to completion.

We validate the results by checking counts per day and also by checking whether
we have any overlapping IDs between prod and the backfilled table:

```
WITH
  ids AS (
  SELECT
    DATE(submission_timestamp) AS dt,
    document_id
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.crash_v4`
  WHERE
    DATE(submission_timestamp) BETWEEN '2019-12-04'
    AND '2020-01-09'
  UNION ALL
  SELECT
    DATE(submission_timestamp) AS dt,
    document_id
  FROM
    `moz-fx-data-backfill-2.telemetry_stable.crash_v4`
  WHERE
    DATE(submission_timestamp) BETWEEN '2019-12-04'
    AND '2020-01-09' ),
  dupes AS (
  SELECT
    dt,
    document_id,
    COUNT(*) AS n
  FROM
    ids
  GROUP BY
    1,
    2
  HAVING
    n > 1)
SELECT
  dt,
  COUNT(*)
FROM
  dupes
GROUP BY
  1
ORDER BY
  1
```

The results show duplicates only on the first and last day of the backfill.

LEARNING: We might want to bake logic into the original query in the Dataflow
job for skipping any document_ids that exist in the prod table. Then we'd
be guaranteed to have a disjoint backfill table that we can blindly use
`bq cp --append_table` to add into prod.

Instead, we'll take advantage of the low data volume here and craft a
query to append this data into the prod table. We do the final append
into prod by running:

```
bq query -n 0 --nouse_legacy_sql \
  --project_id=moz-fx-data-shared-prod \
  --dataset_id=telemetry_stable \
  --destination_table=crash_v4 \
  --append_table \
  < append_to_prod.sql
```

And we're done!

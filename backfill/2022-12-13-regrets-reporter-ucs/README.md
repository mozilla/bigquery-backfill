# Backfill `moz-fx-data-shared-prod.regrets_reporter_ucs_stable.*`

See https://bugzilla.mozilla.org/show_bug.cgi?id=1801828

## 1. Persist snapshot data

The first step is to persist deleted data via BQ time travel into a _private_ dataset (this data is workgroup-confidential):

```bash
#!/bin/bash
# time-sensitive query due to time travel, must be run within 7 days of data rolling off
for ping in deletion-request events main-events regret-details video-data video-index ; do
  table=$(echo "$ping" | sed 's/-/_/g')_v1
  bq cp -a moz-fx-data-shared-prod:regrets_reporter_ucs_stable.${table}@-$(( 604800000 - 60000 )) moz-fx-data-backfill-2:regrets_reporter_ucs_stable.${table}
done
```

## 2. Copy missing data back into source table

Once the [dataset's retention configuration](https://github.com/mozilla/probe-scraper/pull/522) has been updated, missing data needs to be written back into the source table:

```bash
for ping in deletion-request events main-events regret-details video-data video-index ; do
  table=$(echo "$ping" | sed 's/-/_/g')_v1
  bq query --nouse_legacy_sql "INSERT INTO
  \`moz-fx-data-shared-prod.regrets_reporter_ucs_stable.${table}\`
SELECT
  *
FROM
  \`moz-fx-data-backfill-2.regrets_reporter_ucs_stable.${table}\`
WHERE
  DATE(submission_timestamp) NOT IN (  -- this step makes sure that copying the data does not create duplicates
    SELECT DISTINCT DATE(submission_timestamp) FROM \`moz-fx-data-shared-prod.regrets_reporter_ucs_stable.${table}\`
    WHERE DATE(submission_timestamp) > \"2016-01-01\"
  )
AND DATE(submission_timestamp) > \"2016-01-01\""
done
```
 
These queries can only be executed by Data SRE since DE do not have write permissions on confidential data sets.

## 3. Data validation

Check that all of the missing data is available in `moz-fx-data-shared-prod.regrets_reporter_ucs_stable.*`

```sql
SELECT
  MIN(partition_id) AS min_partition,
  table_name
FROM
  `moz-fx-data-shared-prod.regrets_reporter_ucs_stable.INFORMATION_SCHEMA.PARTITIONS`
GROUP BY
  table_name
```

## 4. Delete table with deleted data

Finally, remove the backfill configuration via the corresponding [cloudops-infra terraform PR](https://github.com/mozilla-services/cloudops-infra/pull/4513).

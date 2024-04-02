# `mozilla_mach_stable.usage_v1` backfill

https://bugzilla.mozilla.org/show_bug.cgi?id=1887962

## Context

The Mach Glean app has metrics defined in [`python/mach/metrics.yaml`](https://github.com/mozilla/gecko-dev/blob/master/python/mach/metrics.yaml) and [`python/mozbuild/metrics.yaml`](https://github.com/mozilla/gecko-dev/blob/master/python/mozbuild/metrics.yaml) in 
gecko-dev but the mozbuild path was taken out in [this PR](https://phabricator.services.mozilla.com/D85953) because the 
change to create `mozbuild/metrics.yaml` wasn’t merged yet.  This is the change to move mozbuild metrics from the mach path 
to mozbuild: https://phabricator.services.mozilla.com/D85953.  `python/mozbuild/metrics.yaml` should have been added back 
to the `repositories.yaml` but it wasn’t.  This means metrics added to mozbuild after 2020-09-15 weren’t added to the ping 
schema and the data ended up in the additional properties column.  We want to add the column and backfill it using the 
value in additional properties.

## Backfill

First step is to re-add the metrics file to probe-scraper: https://github.com/mozilla/probe-scraper/pull/718.  
This allows probe scraper to pick up new metrics and the schema generator to create the new columns.  

There’s only one metric added since 2020-09-15: [`mozbuild.project`](https://github.com/mozilla/gecko-dev/commit/127255c31f590a5abccc6478485a214fadbe3e27).  
We can verify the column was added in the following schema generation, https://github.com/mozilla-services/mozilla-pipeline-schemas/commit/64a2652cbf191b9a24fdc11c55d6f828ab2b3eff, 
and after schema deployment, the column is in the ping table with a query on the live table:

```sql
SELECT
  metrics.string.mozbuild_project,
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.mozilla_mach_live.usage_v1`
WHERE
  DATE(submission_timestamp) = "2024-03-28"
GROUP BY
  1
```

Since the values we need to backfill are already in the table, we can backfill the new column using an `UPDATE` statement.

### Testing

Verify json extraction matches the values in the column:

```sql
SELECT
  COALESCE(
    metrics.string.mozbuild_project,
    JSON_VALUE(additional_properties, '$.metrics.string."mozbuild.project"')
  ),
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.mozilla_mach_stable.usage_v1`
WHERE
  DATE(submission_timestamp) = "2024-03-28"
GROUP BY
  1
```

`moz-fx-data-shared-prod.mozilla_mach_stable.usage_v1` is copied to a test table `benwubenwutest.mozilla_mach_stable.usage_v1` 
(full copy because table is small) and the update statement is run on that table.

```sql
UPDATE `benwubenwutest.mozilla_mach_stable.usage_v1`
SET metrics.string.mozbuild_project = JSON_VALUE(additional_properties, '$.metrics.string."mozbuild.project"')
WHERE metrics.string.mozbuild_project IS NULL
  AND submission_timestamp > '2020-10-01'
```

Quick validation of counts and ratios over time:

```sql
WITH counts_per_day AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    metrics.string.mozbuild_project,
    COUNT(*) AS row_count,
  FROM
    `benwubenwutest.mozilla_mach_stable.usage_v1`
  WHERE
    DATE(submission_timestamp) > '2020-10-01'
  GROUP BY
    submission_date, mozbuild_project
)

SELECT
  *,
  row_count / SUM(row_count) OVER (PARTITION BY submission_date) AS ratio
FROM
  counts_per_day
ORDER BY
  submission_date,
  mozbuild_project
```

#### Final update statement on prod table to run is:

```sql
UPDATE `moz-fx-data-shared-prod.mozilla_mach_stable.usage_v1`
SET metrics.string.mozbuild_project = JSON_VALUE(additional_properties, '$.metrics.string."mozbuild.project"')
WHERE metrics.string.mozbuild_project IS NULL
  AND submission_timestamp > '2020-10-20'
```

At the moment, only data SRE has write permissions to the stable tables.  
Ticket to have someone run this https://mozilla-hub.atlassian.net/browse/DSRE-1580

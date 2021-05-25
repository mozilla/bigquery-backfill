# Backfill mobile_usage to fix duplicate client ids in cients first seen

See https://bugzilla.mozilla.org/show_bug.cgi?id=1712790 

The affected dates of duplicates includes 2021-05-23 and 2021-05-24.

Query to verify duplicates in the first seen table:

```sql
SELECT
  client_id,
  COUNT(*) AS n
FROM
  `moz-fx-data-shared-prod.org_mozilla_firefox_derived.baseline_clients_first_seen_v1`
where date(submission_date) > "2020-01-01"
GROUP BY
  1
HAVING
  n > 1
```

and to verify the clients daily table:

```sql
SELECT
  client_id,
  COUNT(*) AS n
FROM
  `moz-fx-data-shared-prod.org_mozilla_firefox_derived.baseline_clients_daily_v1`
where date(submission_date) = "2021-05-23"
GROUP BY
  1
HAVING
  n > 1
```

Update first seen table:

```sql
CREATE OR REPLACE TABLE
  `telemetry_derived.core_clients_first_seen_v1`
PARTITION BY
  (first_seen_date)
AS
SELECT
  client_id,
  DATE(MIN(submission_timestamp)) AS first_seen_date,
FROM
  telemetry.core
WHERE
  submission_timestamp > '2010-01-01'
GROUP BY
  client_id
```

Rewind time to before the incident and run the DAGs for each day. The calculated unix millis for
2021-05-23T23:00:00Z is 1621810800000.

```bash
bq cp org_mozilla_firefox_derived.baseline_clients_first_seen_v1@1621810800000 org_mozilla_firefox_derived.baseline_clients_first_seen_v1
```

After the results of this query looks good, run the following queries.

```bash
bq cp org_mozilla_fenix_derived.baseline_clients_first_seen_v1@1621810800000 org_mozilla_fenix_derived.baseline_clients_first_seen_v1
bq cp org_mozilla_fenix_nightly_derived.baseline_clients_first_seen_v1@1621810800000 org_mozilla_fenix_nightly_derived.baseline_clients_first_seen_v1
bq cp org_mozilla_fennec_aurora_derived.baseline_clients_first_seen_v1@1621810800000 org_mozilla_fennec_aurora_derived.baseline_clients_first_seen_v1
bq cp org_mozilla_firefox_beta_derived.baseline_clients_first_seen_v1@1621810800000 org_mozilla_firefox_beta_derived.baseline_clients_first_seen_v1
```

This is generated using the following statement:

```bash
# repeat for the other tables, run the results of this query
for dataset in org_mozilla_fenix org_mozilla_fenix_nightly org_mozilla_fennec_aurora org_mozilla_firefox_beta; do
    echo bq cp ${dataset}_derived.baseline_clients_first_seen_v1@1621810800000 ${dataset}_derived.baseline_clients_first_seen_v1;
done
```

The affected days are cleared from airflow and rerun:

```
<TaskInstance: copy_deduplicate.baseline_clients_daily 2021-05-23 01:00:00+00:00 [success]>
<TaskInstance: copy_deduplicate.baseline_clients_daily 2021-05-24 01:00:00+00:00 [success]>
<TaskInstance: copy_deduplicate.baseline_clients_first_seen 2021-05-23 01:00:00+00:00 [success]>
<TaskInstance: copy_deduplicate.baseline_clients_first_seen 2021-05-24 01:00:00+00:00 [success]>
<TaskInstance: copy_deduplicate.baseline_clients_last_seen 2021-05-23 01:00:00+00:00 [success]>
<TaskInstance: copy_deduplicate.baseline_clients_last_seen 2021-05-24 01:00:00+00:00 [success]>
```

Also clear relevant dags in the `bqetl_core` DAG. After this is complete, clear
`bqetl_nondesktop`, finally followed by `bqetl_gud`.
# Backfill `contextual_services_derived.event_aggregates_v1`

See https://docs.google.com/document/d/1HHQn1pnLJ2IC2l5DvMG0pshHqIusptSp_8cOogzZ4LU/edit#heading=h.p64b1qfksx4w

Contextual Service source datasets only contain the most recent 30 days of data. So our normal backfill process for derived datasets of simply rerunning the queries does not apply here. A backfill can only be run on the last 30 days of data, anything older than that **will result in data loss**.

Data can be recovered within 7 days of when data was deleted.

## 1. Write persist snapshot data

The first step is to write deleted data into a _private_ dataset (this data is confidential):

```sql
CREATE TABLE `some-locked-down-sandbox-project.contextual_services_derived.event_aggregates_v1` AS (
  SELECT
    *
  FROM
    `contextual_services_derived.event_aggregates_v1`
    FOR SYSTEM_TIME AS OF
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 12 HOUR) -- the interval needs to point to some timeframe from before the data was removed
)
```

Access to the dataset is restricted, so only individuals with the necessary access permissions can run the query.
This step needs to happen within 7 days of when the data loss occurred.

## 2. Copy missing data back into source table

Once the missing data has been written into a dataset, missing data needs to be written back into the source table:

```sql
INSERT INTO 
  `moz-fx-data-shared-prod.contextual_services_derived.event_aggregates_v1`
SELECT 
  * 
FROM 
  `some-locked-down-sandbox-project.contextual_services_derived.event_aggregates_v1` 
WHERE 
  submission_date NOT IN (  -- this step makes sure that copying the data does not create duplicates
    SELECT DISTINCT submission_date FROM contextual_services_derived.event_aggregates_v1
    WHERE submission_date > "2016-01-01"
  )
```

This query can only be executed by Data SRE since users do not have write permissions on confidential data sets.
Open a ticket [here](https://mozilla-hub.atlassian.net/jira/software/c/projects/DSRE/issues/) and provide the query inside the ticket description that SRE is supposed to run.

It is recommended to open a ticket in [Bugzilla](https://bugzilla.mozilla.org/buglist.cgi?product=Data%20Platform%20and%20Tools&component=General&resolution=---&list_id=16270083) for this step and have someone else review the query.

## 3. Data validation

Check that all of the missing data is available in `moz-fx-data-shared-prod.contextual_services_derived.event_aggregates_v1`

## 4. Delete table with deleted data

Finally, remove the table with the deleted entries: 

```sql
DROP TABLE `some-locked-down-sandbox-project.contextual_services_derived.event_aggregates_v1` 
```

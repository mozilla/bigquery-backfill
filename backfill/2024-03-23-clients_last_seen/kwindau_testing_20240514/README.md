Testing workaround for creating: moz-fx-data-shared-prod.telemetry_derived.desktop_clients_last_seen_v2

Steps Used to Test:
1. Copy `moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v1` to `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits` (using Step1/copy.txt bq copy command)
2. Clone bigquery-etl repo
```
git clone git@github.com:mozilla/bigquery-etl.git
```
3. Copy the 3 files in the "step2" folder into the cloned bigquery ETL repo at the following new path:
```
sql/moz-fx-data-shared-prod/telemetry_derived/kwindau_days_active_bits
```
* NOTE - if this test works and we end up doing this, make sure to edit line 24 of the query to be the correct table name

4. Run the below to create an empty table and then backfill for a single sample ID for a date range
```
pyenv local 3.11
./bqetl bootstrap
gcloud auth login
./bqetl query schema deploy telemetry_derived.kwindau_days_active_bits --project_id=moz-fx-data-shared-prod --force
./bqetl query backfill telemetry_derived.kwindau_days_active_bits --project_id=moz-fx-data-shared-prod --start-date=2016-03-12 --end-date=2017-01-31
```
5. Add a new, null column onto our table moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits
```
ALTER TABLE `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits`
ADD COLUMN days_active_bits INT64;
```

7. Merge the result into our copy of clients last seen v1 named "moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits"
```
MERGE INTO `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits`
--??


```
7. Run a counts QA comparison to make sure things match
```
--?
SELECT count(1)
FROM ``;

--?
SELECT count(1)
FROM ``;
```
8. Make sure all values exactly match
```
--exact row match check #1 
SELECT *
FROM
except distinct
SELECT *
FROM ?

--exact row match check #2
SELECT *
FROM
except distinct
SELECT *
FROM ? 
```

**NOTE: If we go this approach, we will have to make sure we update the production SQL to have the column "days_active_bits" at the end in both the schema and in the query.sql file**

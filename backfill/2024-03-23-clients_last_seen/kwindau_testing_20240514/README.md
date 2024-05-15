**Testing Alternative Method for Creating: moz-fx-data-shared-prod.telemetry_derived.desktop_clients_last_seen_v2**

**Steps Used to Test:**
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
./bqetl query backfill telemetry_derived.kwindau_days_active_bits --project_id=moz-fx-data-shared-prod --start-date=2016-03-12 --end-date=2017-01-18
```
5. Add a new, null column onto our table moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits
```
ALTER TABLE `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits`
ADD COLUMN days_active_bits INT64;
```

7. Merge the result into our copy of clients last seen v1 named "moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits"
```
--part 1: 3/12/16 - 4/12/16
MERGE INTO `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits` T 
USING
(
  SELECT a.* EXCEPT (days_active_bits),
  b.days_active_bits 
  FROM `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits` a
  LEFT JOIN
  `moz-fx-data-shared-prod.telemetry_derived.kwindau_days_active_bits` b
  ON a.client_id = b.client_id
  and a.submission_date = b.submission_date
  WHERE a.submission_date BETWEEN '2016-03-12' AND '2016-04-12'
) S
ON T.client_id = S.client_id
AND T.submission_date = S.submission_date
WHEN MATCHED THEN
  UPDATE
    SET T.days_active_bits = S.days_active_bits;

--part 2: 4/13/16 - 6/13/16
MERGE INTO `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits` T 
USING
(
  SELECT a.* EXCEPT (days_active_bits),
  b.days_active_bits 
  FROM `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits` a
  LEFT JOIN
  `moz-fx-data-shared-prod.telemetry_derived.kwindau_days_active_bits` b
  ON a.client_id = b.client_id
  and a.submission_date = b.submission_date
  WHERE a.submission_date BETWEEN '2016-04-13' AND '2016-06-13'
) S
ON T.client_id = S.client_id
AND T.submission_date = S.submission_date
WHEN MATCHED THEN
  UPDATE
    SET T.days_active_bits = S.days_active_bits;

--part 3: 6/14/16 - 8/14/16

--part 4: 8/15/16 - 10/15/16

--part 5: 10/16/16 - 12/16/16

--part 6: 12/17/16 - 1/18/17
```
7. Run a sanity check to make sure # of rows still matches between clients_last_seen_v1 and the new table with the column added for the same date range
```
--87,148,685,988
SELECT count(1) 
FROM `moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v1`
WHERE submission_date BETWEEN '2016-03-12' AND '2017-01-18'

--?
SELECT count(1), min(submission_date), max(submission_date)
FROM `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits`;
```

8. Compare the backfill done via the old method vs the backfill done via the new method to make sure they produced the same results for the same time period
    Note: Only look at client IDs done via a sample ID that worked OK - for example, let's check sample ID = 1
    If everything worked OK, both queries below should return 0 rows
```
--exact row match check #1 
SELECT   submission_date,
  first_seen_date,
  second_seen_date,
  days_seen_bits,
  days_active_bits,
  days_visited_1_uri_bits,
  days_visited_5_uri_bits,
  days_visited_10_uri_bits,
  days_had_8_active_ticks_bits,
  days_opened_dev_tools_bits,
  days_interacted_bits,
  days_visited_1_uri_normal_mode_bits,
  days_visited_1_uri_private_mode_bits,
  days_created_profile_bits,
  days_seen_in_experiment,
  * EXCEPT (
    submission_date,
    first_seen_date,
    second_seen_date,
    days_seen_bits,
    days_active_bits,
    days_visited_1_uri_bits,
    days_visited_5_uri_bits,
    days_visited_10_uri_bits,
    days_had_8_active_ticks_bits,
    days_opened_dev_tools_bits,
    days_interacted_bits,
    days_visited_1_uri_normal_mode_bits,
    days_visited_1_uri_private_mode_bits,
    days_created_profile_bits,
    days_seen_in_experiment
    )
FROM `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits`
WHERE sample_id = 1
AND submission_date BETWEEN '2016-03-12' AND '2017-01-18'
except distinct
SELECT   submission_date,
  first_seen_date,
  second_seen_date,
  days_seen_bits,
  days_active_bits,
  days_visited_1_uri_bits,
  days_visited_5_uri_bits,
  days_visited_10_uri_bits,
  days_had_8_active_ticks_bits,
  days_opened_dev_tools_bits,
  days_interacted_bits,
  days_visited_1_uri_normal_mode_bits,
  days_visited_1_uri_private_mode_bits,
  days_created_profile_bits,
  days_seen_in_experiment,
  * EXCEPT (
    submission_date,
    first_seen_date,
    second_seen_date,
    days_seen_bits,
    days_active_bits,
    days_visited_1_uri_bits,
    days_visited_5_uri_bits,
    days_visited_10_uri_bits,
    days_had_8_active_ticks_bits,
    days_opened_dev_tools_bits,
    days_interacted_bits,
    days_visited_1_uri_normal_mode_bits,
    days_visited_1_uri_private_mode_bits,
    days_created_profile_bits,
    days_seen_in_experiment
    )
FROM `moz-fx-data-shared-prod.backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_1`
WHERE submission_date BETWEEN  '2016-03-12' AND '2017-01-18'

--exact row match check #2
SELECT   submission_date,
  first_seen_date,
  second_seen_date,
  days_seen_bits,
  days_active_bits,
  days_visited_1_uri_bits,
  days_visited_5_uri_bits,
  days_visited_10_uri_bits,
  days_had_8_active_ticks_bits,
  days_opened_dev_tools_bits,
  days_interacted_bits,
  days_visited_1_uri_normal_mode_bits,
  days_visited_1_uri_private_mode_bits,
  days_created_profile_bits,
  days_seen_in_experiment,
  * EXCEPT (
    submission_date,
    first_seen_date,
    second_seen_date,
    days_seen_bits,
    days_active_bits,
    days_visited_1_uri_bits,
    days_visited_5_uri_bits,
    days_visited_10_uri_bits,
    days_had_8_active_ticks_bits,
    days_opened_dev_tools_bits,
    days_interacted_bits,
    days_visited_1_uri_normal_mode_bits,
    days_visited_1_uri_private_mode_bits,
    days_created_profile_bits,
    days_seen_in_experiment
    )
FROM `moz-fx-data-shared-prod.backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_1`
WHERE submission_date BETWEEN '2016-03-12' AND '2017-01-18'
except distinct
SELECT   submission_date,
  first_seen_date,
  second_seen_date,
  days_seen_bits,
  days_active_bits,
  days_visited_1_uri_bits,
  days_visited_5_uri_bits,
  days_visited_10_uri_bits,
  days_had_8_active_ticks_bits,
  days_opened_dev_tools_bits,
  days_interacted_bits,
  days_visited_1_uri_normal_mode_bits,
  days_visited_1_uri_private_mode_bits,
  days_created_profile_bits,
  days_seen_in_experiment,
  * EXCEPT (
    submission_date,
    first_seen_date,
    second_seen_date,
    days_seen_bits,
    days_active_bits,
    days_visited_1_uri_bits,
    days_visited_5_uri_bits,
    days_visited_10_uri_bits,
    days_had_8_active_ticks_bits,
    days_opened_dev_tools_bits,
    days_interacted_bits,
    days_visited_1_uri_normal_mode_bits,
    days_visited_1_uri_private_mode_bits,
    days_created_profile_bits,
    days_seen_in_experiment
    )
FROM `moz-fx-data-shared-prod.telemetry_derived.kwindau_clients_last_seen_v2_including_active_bits`
WHERE sample_id = 1
AND submission_date BETWEEN '2016-03-12' AND '2017-01-18'
```
9. Drop the additional table since no longer needed
```
DROP TABLE  `moz-fx-data-shared-prod.telemetry_derived.kwindau_days_active_bits`
```

**NOTE: If we go this approach, we will have to make sure we update the production SQL to have the column "days_active_bits" at the end in both the schema and in the query.sql file**

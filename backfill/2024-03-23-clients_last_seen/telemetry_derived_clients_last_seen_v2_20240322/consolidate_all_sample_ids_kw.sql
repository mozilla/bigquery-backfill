--create the table
CREATE OR REPLACE TABLE `moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v2_20240421`
PARTITION BY submission_date
CLUSTER BY normalized_channel, sample_id
OPTIONS(
  friendly_name = "Clients Last Seen",
  description = "Aggregations that show a rolling 28-day per-client summary on top of `clients_daily_*` tables.  It performs a join with `clients_first_seen` to provide fields related to client activation that fall outside the 28-day window e.g. first and second_seen date. From Q4 2023, the query joins with `clients_first_seen_v2`, based on the redefinition of New Profiles: https://docs.google.com/document/d/1B-zTNwschQgljij19Ez104qRV5RUC9zwjSN9tc1C8vc/edit#heading=h.gcjj37lkgqer. It should normally be accessed through the user-facing view `telemetry.clients_last_seen`. Note that by end of Q1 2021, that view start referencing the downstream table `clients_last_seen_joined_v1` which merges in fields based on the `event` ping. See https://github.com/mozilla/bigquery-etl/issues/1761",
  require_partition_filter = TRUE
)
AS
SELECT * 
FROM `moz-fx-data-shared-prod.backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_0`

--append everything to this table

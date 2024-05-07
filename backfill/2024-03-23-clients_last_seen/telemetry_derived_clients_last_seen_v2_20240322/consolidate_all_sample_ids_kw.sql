--STEP 1: Create an empty table using the cluster order the original source tables have to make using bq cp work (cost efficient/faster)
CREATE OR REPLACE TABLE `moz-fx-data-shared-prod.telemetry_derived.clients_last_seen_v2_20240507`
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
limit 0;

--Run 199 different copy commands to append sample IDs 0 - 99 
--Note: For now, I skipped running sample IDs 60 - 69 because they look incomplete / missing a few days of data
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_0 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_1 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_2 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_3 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_4 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_5 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_6 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_7 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_8 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_9 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_10 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_11 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_12 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_13 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_14 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_15 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_16 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_17 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_18 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_19 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_20 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_21 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_22 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_23 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_24 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_25 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_26 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507	
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_27 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_28 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_29 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_30 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_31 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507	
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_32 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_33 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_34 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_35 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_36 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_37 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_38 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_39 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_40 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_41 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_42 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_43 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_44 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_45 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_46 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_47 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_48 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_49 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_50 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_51 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_52 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_53 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_54 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_55 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_56 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_57 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_58 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_59 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_60 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_61 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_62 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_63 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_64 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_65 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_66 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_67 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_68 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507	
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_69 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_70 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_71 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_72 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_73 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_74 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_75 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_76 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_77 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_78 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_79 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_80 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_81 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_82 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_83 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507	
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_84 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_85 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_86 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_87 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_88 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-backfill-1:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_89 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_90 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_91 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507  
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_92 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_93 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_94 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_95 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_96 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507    
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_97 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_98 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507
bq cp --append_table=true moz-fx-data-shared-prod:backfills_staging_derived.telemetry_derived_clients_last_seen_v2_20230322_99 moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507

--make a backup of the final in case something bad happens with clustering order change
bq cp moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_v2_20240507  moz-fx-data-shared-prod:telemetry_derived.clients_last_seen_V2_20240507_bkp

--update the clustering order

--create a view with the desired order of columns


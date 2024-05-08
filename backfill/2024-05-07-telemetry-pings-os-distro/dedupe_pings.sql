-- bhr_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.bhr_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.bhr_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.bhr_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- crash_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.crash_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.crash_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.crash_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- event_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.event_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.event_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.event_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- first_shutdown_use_counter_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.first_shutdown_use_counter_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_use_counter_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_use_counter_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- first_shutdown_v5
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.first_shutdown_v5` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_v5` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_v5`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- heartbeat_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.heartbeat_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.heartbeat_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.heartbeat_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- main_use_counter_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_use_counter_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.main_use_counter_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.main_use_counter_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- main_v5
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_v5` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.main_v5` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.main_v5`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- modules_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.modules_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.modules_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.modules_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- new_profile_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.new_profile_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.new_profile_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.new_profile_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- sync_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.sync_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.sync_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.sync_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

-- update_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.update_v4` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.update_v4` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.update_v4`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);

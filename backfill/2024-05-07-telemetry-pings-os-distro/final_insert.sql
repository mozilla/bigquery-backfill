-- bhr_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.bhr_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.bhr_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- crash_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.crash_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.crash_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- event_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.event_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.event_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- first_shutdown_use_counter_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.first_shutdown_use_counter_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.first_shutdown_use_counter_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- first_shutdown_v5
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.first_shutdown_v5`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.first_shutdown_v5`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- heartbeat_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.heartbeat_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.heartbeat_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- main_use_counter_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.main_use_counter_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_use_counter_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- main_v5
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.main_v5`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_v5`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- modules_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.modules_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.modules_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- new_profile_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.new_profile_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.new_profile_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- sync_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.sync_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.sync_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

-- update_v4
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.update_v4`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.update_v4`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02';

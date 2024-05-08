-- bhr_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.bhr_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.bhr_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.bhr_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.bhr_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- crash_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.crash_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.crash_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.crash_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.crash_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- event_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.event_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.event_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.event_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.event_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- first_shutdown_use_counter_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.first_shutdown_use_counter_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_use_counter_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.first_shutdown_use_counter_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_use_counter_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- first_shutdown_v5
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.first_shutdown_v5`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_v5` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.first_shutdown_v5`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.first_shutdown_v5` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- heartbeat_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.heartbeat_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.heartbeat_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.heartbeat_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.heartbeat_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- main_use_counter_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_use_counter_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.main_use_counter_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.main_use_counter_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.main_use_counter_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- main_v5
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_v5`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.main_v5` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.main_v5`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.main_v5` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- modules_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.modules_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.modules_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.modules_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.modules_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- new_profile_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.new_profile_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.new_profile_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.new_profile_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.new_profile_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- sync_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.sync_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.sync_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.sync_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.sync_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

-- update_v4
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.update_v4`
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.update_v4` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.telemetry_stable.update_v4`
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.telemetry_os_distro_output.update_v4` 
    WHERE 
      DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
    QUALIFY 
      ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
  )
  SELECT
    new_rows.*
  FROM
    new_rows
  LEFT JOIN
    existing_doc_ids
  USING
    (document_id)
  WHERE
    existing_doc_ids.document_id IS NULL
);

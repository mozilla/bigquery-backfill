SELECT
  * REPLACE ( (
    SELECT
      AS STRUCT payload.* REPLACE ((
        SELECT
          AS STRUCT payload.metadata.* REPLACE (COALESCE(payload.metadata.moz_crash_reason,
              JSON_EXTRACT_SCALAR(additional_properties,
                '$.payload.metadata.MozCrashReason')) AS moz_crash_reason)) AS metadata)) AS payload)
FROM (
  SELECT
    * REPLACE ( (
      SELECT
        AS STRUCT payload.* REPLACE ((
          SELECT
            AS STRUCT payload.metadata.* REPLACE (COALESCE(payload.metadata.oom_allocation_size,
                JSON_EXTRACT_SCALAR(additional_properties,
                  '$.payload.metadata.OOMAllocationSize')) AS oom_allocation_size)) AS metadata)) AS payload)
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.crash_v4`
  WHERE
    DATE(submission_timestamp) > '2019-06-01' and date(submission_timestamp) < '2019-11-14')
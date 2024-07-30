WITH v2_data AS (
  SELECT 
  * EXCEPT (normalized_os) 
  FROM `moz-fx-data-shared-prod.telemetry_derived.clients_first_seen_v2`
  WHERE first_seen_date = @backfill_date
), 

np_ping_data AS (
  SELECT client_id,
    DATE(np.submission_timestamp) AS submission_date,
    ARRAY_AGG(np.metadata.isp.name RESPECT NULLS ORDER BY submission_timestamp)[
    SAFE_OFFSET(0)
    ] AS isp_name,
    ARRAY_AGG(
      np.environment.settings.attribution.variation RESPECT NULLS
      ORDER BY
        submission_timestamp
    )[SAFE_OFFSET(0)] AS attribution_variation,
    ARRAY_AGG(
    mozfun.norm.os(np.environment.system.os.name) RESPECT NULLS
    ORDER BY
      submission_timestamp
  )[SAFE_OFFSET(0)] AS normalized_os,
  ARRAY_AGG(np.environment.system.os.name RESPECT NULLS ORDER BY submission_timestamp)[
    SAFE_OFFSET(0)
    ] AS os,
  ARRAY_AGG(np.environment.system.os.version RESPECT NULLS ORDER BY submission_timestamp)[
    SAFE_OFFSET(0)
    ] AS os_version,
    ARRAY_AGG(
    np.environment.system.os.windows_build_number RESPECT NULLS
    ORDER BY
      submission_timestamp
    )[SAFE_OFFSET(0)] AS windows_build_number,
    CAST(NULL AS BOOL) AS installation_first_seen_admin_user,
    CAST(NULL AS BOOL) AS installation_first_seen_default_path,
    CAST(NULL AS STRING) AS installation_first_seen_failure_reason,
    CAST(NULL AS BOOL) AS installation_first_seen_from_msi,
    CAST(NULL AS BOOL) AS installation_first_seen_install_existed,
    CAST(NULL AS STRING) AS installation_first_seen_installer_type,
    CAST(NULL AS BOOL) AS installation_first_seen_other_inst,
    CAST(NULL AS BOOL) AS installation_first_seen_other_msix_inst,
    CAST(NULL AS BOOL) AS installation_first_seen_profdir_existed,
    CAST(NULL AS BOOL) AS installation_first_seen_silent,
    CAST(NULL AS STRING) AS installation_first_seen_version,
  FROM v2_data v2
  LEFT JOIN 
   `moz-fx-data-shared-prod.telemetry.new_profile` np
   USING(client_id)
  WHERE v2.metadata.first_seen_date_source_ping = "new_profile"
  AND DATE(np.submission_timestamp) = @backfill_date
    GROUP BY
    client_id,
    submission_date
),

sd_ping_data AS 
(
  SELECT client_id,
    DATE(fs.submission_timestamp) AS submission_date,
    ARRAY_AGG(fs.metadata.isp.name RESPECT NULLS ORDER BY submission_timestamp)[
        SAFE_OFFSET(0)
      ] AS isp_name,
    ARRAY_AGG(
      fs.environment.settings.attribution.variation RESPECT NULLS
      ORDER BY
        submission_timestamp
    )[SAFE_OFFSET(0)] AS attribution_variation,
    ARRAY_AGG(
        mozfun.norm.os(fs.environment.system.os.name) RESPECT NULLS
        ORDER BY
          submission_timestamp
      )[SAFE_OFFSET(0)] AS normalized_os,
    ARRAY_AGG(fs.environment.system.os.name RESPECT NULLS ORDER BY submission_timestamp)[
        SAFE_OFFSET(0)
      ] AS os,
    ARRAY_AGG(fs.environment.system.os.version RESPECT NULLS ORDER BY submission_timestamp)[
        SAFE_OFFSET(0)
      ] AS os_version,
    ARRAY_AGG(
        fs.environment.system.os.windows_build_number RESPECT NULLS
        ORDER BY
          submission_timestamp
      )[SAFE_OFFSET(0)] AS windows_build_number,
    CAST(NULL AS BOOL) AS installation_first_seen_admin_user,
    CAST(NULL AS BOOL) AS installation_first_seen_default_path,
    CAST(NULL AS STRING) AS installation_first_seen_failure_reason,
    CAST(NULL AS BOOL) AS installation_first_seen_from_msi,
    CAST(NULL AS BOOL) AS installation_first_seen_install_existed,
    CAST(NULL AS STRING) AS installation_first_seen_installer_type,
    CAST(NULL AS BOOL) AS installation_first_seen_other_inst,
    CAST(NULL AS BOOL) AS installation_first_seen_other_msix_inst,
    CAST(NULL AS BOOL) AS installation_first_seen_profdir_existed,
    CAST(NULL AS BOOL) AS installation_first_seen_silent,
    CAST(NULL AS STRING) AS installation_first_seen_version,
  FROM v2_data v2
  LEFT JOIN 
   `moz-fx-data-shared-prod.telemetry.first_shutdown` fs
   USING(client_id)
  WHERE v2.metadata.first_seen_date_source_ping = "shutdown"
  AND DATE(fs.submission_timestamp) = @backfill_date
    GROUP BY
    client_id,
    submission_date
),

main_ping_data AS 
(
  SELECT client_id,
    mp.submission_date,
    ARRAY_AGG(mp.isp_name RESPECT NULLS ORDER BY submission_date)[SAFE_OFFSET(0)
    ] AS isp_name,
    ARRAY_AGG(attribution.variation RESPECT NULLS ORDER BY submission_date)[
      SAFE_OFFSET(0)
    ] AS attribution_variation,
    ARRAY_AGG(mozfun.norm.os(mp.os) RESPECT NULLS ORDER BY submission_date)[
      SAFE_OFFSET(0)
    ] AS normalized_os,
    ARRAY_AGG(os RESPECT NULLS ORDER BY submission_date)[SAFE_OFFSET(0)] AS os,
    ARRAY_AGG(os_version RESPECT NULLS ORDER BY submission_date)[SAFE_OFFSET(0)] AS os_version,
    ARRAY_AGG(mp.windows_build_number RESPECT NULLS ORDER BY submission_date)[
      SAFE_OFFSET(0)
    ] AS windows_build_number_raw,
    CAST(NULL AS BOOL) AS installation_first_seen_admin_user,
    CAST(NULL AS BOOL) AS installation_first_seen_default_path,
    CAST(NULL AS STRING) AS installation_first_seen_failure_reason,
    CAST(NULL AS BOOL) AS installation_first_seen_from_msi,
    CAST(NULL AS BOOL) AS installation_first_seen_install_existed,
    CAST(NULL AS STRING) AS installation_first_seen_installer_type,
    CAST(NULL AS BOOL) AS installation_first_seen_other_inst,
    CAST(NULL AS BOOL) AS installation_first_seen_other_msix_inst,
    CAST(NULL AS BOOL) AS installation_first_seen_profdir_existed,
    CAST(NULL AS BOOL) AS installation_first_seen_silent,
    CAST(NULL AS STRING) AS installation_first_seen_version,
  FROM v2_data v2
  LEFT JOIN 
   `moz-fx-data-shared-prod.telemetry_derived.clients_daily_v6` mp
   USING(client_id)
  WHERE v2.metadata.first_seen_date_source_ping = "shutdown"
  AND submission_date = @backfill_date
  GROUP BY
    client_id,
    submission_date
),

unioned AS (
  SELECT * from np_ping_data
  UNION ALL
  SELECT * FROM sd_ping_data
  UNION ALL
  SELECT client_id,
    submission_date,
    isp_name,
    attribution_variation,
    normalized_os,
    os,
    os_version,
    CAST(windows_build_number_raw AS FLOAT64) AS windows_build_number,
    installation_first_seen_admin_user,
    installation_first_seen_default_path,
    installation_first_seen_failure_reason,
    installation_first_seen_from_msi,
    installation_first_seen_install_existed,
    installation_first_seen_installer_type,
    installation_first_seen_other_inst,
    installation_first_seen_other_msix_inst,
    installation_first_seen_profdir_existed,
    installation_first_seen_silent,
    installation_first_seen_version,
  FROM main_ping_data
),

combined AS (
  select v2.*,
  u.normalized_os, 
  u.isp_name,
  u.os,
  u.os_version,
  u.windows_build_number,
  mozfun.norm.windows_version_info(
      u.os,
      u.os_version,
      CAST(u.windows_build_number AS INT64)
    ) AS windows_version,
  u.attribution_variation,
  u.installation_first_seen_admin_user,
  u.installation_first_seen_default_path,
  u.installation_first_seen_failure_reason,
  u.installation_first_seen_from_msi,
  u.installation_first_seen_install_existed,
  u.installation_first_seen_installer_type,
  u.installation_first_seen_other_inst,
  u.installation_first_seen_other_msix_inst,
  u.installation_first_seen_profdir_existed,
  u.installation_first_seen_silent,
  u.installation_first_seen_version
  from v2_data v2
  LEFT JOIN unioned u
  ON u.client_id = v2.client_id
  AND u.submission_date = v2.first_seen_date
)


SELECT
  client_id,
  sample_id,
  first_seen_date,
  second_seen_date,
  architecture,
  app_build_id,
  app_name,
  locale,
  platform_version,
  vendor,
  app_version,
  xpcom_abi,
  document_id,
  distribution_id,
  partner_distribution_version,
  partner_distributor,
  partner_distributor_channel,
  partner_id,
  attribution_campaign,
  attribution_content,
  attribution_dltoken,
  attribution_dlsource,
  attribution_experiment,
  attribution_medium,
  attribution_source,
  attribution_ua,
  attribution_variation,
  engine_data_load_path,
  engine_data_name,
  engine_data_origin,
  engine_data_submission_url,
  apple_model_id,
  city,
  db_version,
  subdivision1,
  isp_name,
  normalized_channel,
  country,
  normalized_os,
  normalized_os_version,
  startup_profile_selection_reason,
  installation_first_seen_admin_user,
  installation_first_seen_default_path,
  installation_first_seen_failure_reason,
  installation_first_seen_from_msi,
  installation_first_seen_install_existed,
  installation_first_seen_installer_type,
  installation_first_seen_other_inst,
  installation_first_seen_other_msix_inst,
  installation_first_seen_profdir_existed,
  installation_first_seen_silent,
  installation_first_seen_version,
  os,
  os_version,
  windows_build_number,
  windows_version,
  metadata
FROM combined

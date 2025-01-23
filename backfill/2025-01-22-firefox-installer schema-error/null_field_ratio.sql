SELECT
  "full_installer_backfill" AS source,
  COUNT(_64bit_build) / COUNT(*) AS _64bit_build_non_null_ratio,
  COUNT(_64bit_os) / COUNT(*) AS _64bit_os_non_null_ratio,
  COUNT(admin_user) / COUNT(*) AS admin_user_non_null_ratio,
  COUNT(attribution) / COUNT(*) AS attribution_non_null_ratio,
  COUNT(build_channel) / COUNT(*) AS build_channel_non_null_ratio,
  COUNT(build_id) / COUNT(*) AS build_id_non_null_ratio,
  COUNT(bytes_downloaded) / COUNT(*) AS bytes_downloaded_non_null_ratio,
  COUNT(default_path) / COUNT(*) AS default_path_non_null_ratio,
  COUNT(disk_space_error) / COUNT(*) AS disk_space_error_non_null_ratio,
  COUNT(disk_space_req_not_met) / COUNT(*) AS disk_space_req_not_met_non_null_ratio,
  COUNT(distribution_id) / COUNT(*) AS distribution_id_non_null_ratio,
  COUNT(distribution_version) / COUNT(*) AS distribution_version_non_null_ratio,
  COUNT(document_id) / COUNT(*) AS document_id_non_null_ratio,
  COUNT(download_ip) / COUNT(*) AS download_ip_non_null_ratio,
  COUNT(download_latency) / COUNT(*) AS download_latency_non_null_ratio,
  COUNT(download_retries) / COUNT(*) AS download_retries_non_null_ratio,
  COUNT(download_size) / COUNT(*) AS download_size_non_null_ratio,
  COUNT(download_time) / COUNT(*) AS download_time_non_null_ratio,
  COUNT(file_error) / COUNT(*) AS file_error_non_null_ratio,
  COUNT(finish_time) / COUNT(*) AS finish_time_non_null_ratio,
  COUNT(from_msi) / COUNT(*) AS from_msi_non_null_ratio,
  COUNT(funnelcake) / COUNT(*) AS funnelcake_non_null_ratio,
  COUNT(had_old_install) / COUNT(*) AS had_old_install_non_null_ratio,
  COUNT(hardware_req_not_met) / COUNT(*) AS hardware_req_not_met_non_null_ratio,
  COUNT(install_time) / COUNT(*) AS install_time_non_null_ratio,
  COUNT(install_timeout) / COUNT(*) AS install_timeout_non_null_ratio,
  COUNT(installer_type) / COUNT(*) AS installer_type_non_null_ratio,
  COUNT(installer_version) / COUNT(*) AS installer_version_non_null_ratio,
  COUNT(intro_time) / COUNT(*) AS intro_time_non_null_ratio,
  COUNT(locale) / COUNT(*) AS locale_non_null_ratio,
  COUNT(manual_download) / COUNT(*) AS manual_download_non_null_ratio,
  COUNT(new_default) / COUNT(*) AS new_default_non_null_ratio,
  COUNT(new_launched) / COUNT(*) AS new_launched_non_null_ratio,
  COUNT(no_write_access) / COUNT(*) AS no_write_access_non_null_ratio,
  COUNT(normalized_app_name) / COUNT(*) AS normalized_app_name_non_null_ratio,
  COUNT(normalized_channel) / COUNT(*) AS normalized_channel_non_null_ratio,
  COUNT(normalized_country_code) / COUNT(*) AS normalized_country_code_non_null_ratio,
  COUNT(normalized_os) / COUNT(*) AS normalized_os_non_null_ratio,
  COUNT(normalized_os_version) / COUNT(*) AS normalized_os_version_non_null_ratio,
  COUNT(old_build_id) / COUNT(*) AS old_build_id_non_null_ratio,
  COUNT(old_default) / COUNT(*) AS old_default_non_null_ratio,
  COUNT(old_running) / COUNT(*) AS old_running_non_null_ratio,
  COUNT(old_version) / COUNT(*) AS old_version_non_null_ratio,
  COUNT(options_time) / COUNT(*) AS options_time_non_null_ratio,
  COUNT(os_version) / COUNT(*) AS os_version_non_null_ratio,
  COUNT(os_version_req_not_met) / COUNT(*) AS os_version_req_not_met_non_null_ratio,
  COUNT(out_of_retries) / COUNT(*) AS out_of_retries_non_null_ratio,
  COUNT(ping_version) / COUNT(*) AS ping_version_non_null_ratio,
  COUNT(preinstall_time) / COUNT(*) AS preinstall_time_non_null_ratio,
  COUNT(profile_cleanup_prompt) / COUNT(*) AS profile_cleanup_prompt_non_null_ratio,
  COUNT(profile_cleanup_requested) / COUNT(*) AS profile_cleanup_requested_non_null_ratio,
  COUNT(sample_id) / COUNT(*) AS sample_id_non_null_ratio,
  COUNT(server_os) / COUNT(*) AS server_os_non_null_ratio,
  COUNT(service_pack) / COUNT(*) AS service_pack_non_null_ratio,
  COUNT(set_default) / COUNT(*) AS set_default_non_null_ratio,
  COUNT(sig_check_timeout) / COUNT(*) AS sig_check_timeout_non_null_ratio,
  COUNT(sig_not_trusted) / COUNT(*) AS sig_not_trusted_non_null_ratio,
  COUNT(sig_unexpected) / COUNT(*) AS sig_unexpected_non_null_ratio,
  COUNT(silent) / COUNT(*) AS silent_non_null_ratio,
  COUNT(stub_build_id) / COUNT(*) AS stub_build_id_non_null_ratio,
  COUNT(submission_timestamp) / COUNT(*) AS submission_timestamp_non_null_ratio,
  COUNT(succeeded) / COUNT(*) AS succeeded_non_null_ratio,
  COUNT(unknown_error) / COUNT(*) AS unknown_error_non_null_ratio,
  COUNT(update_channel) / COUNT(*) AS update_channel_non_null_ratio,
  COUNT(user_cancelled) / COUNT(*) AS user_cancelled_non_null_ratio,
  COUNT(version) / COUNT(*) AS version_non_null_ratio,
  COUNT(windows_ubr) / COUNT(*) AS windows_ubr_non_null_ratio,
  COUNT(writeable_req_not_met) / COUNT(*) AS writeable_req_not_met_non_null_ratio,
FROM
  `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
WHERE
  DATE(submission_timestamp) <= "2025-01-23"
  AND ping_version IS NULL
UNION ALL
SELECT
  "full_installer_existing" AS source,
  COUNT(_64bit_build) / COUNT(*) AS _64bit_build_non_null_ratio,
  COUNT(_64bit_os) / COUNT(*) AS _64bit_os_non_null_ratio,
  COUNT(admin_user) / COUNT(*) AS admin_user_non_null_ratio,
  COUNT(attribution) / COUNT(*) AS attribution_non_null_ratio,
  COUNT(build_channel) / COUNT(*) AS build_channel_non_null_ratio,
  COUNT(build_id) / COUNT(*) AS build_id_non_null_ratio,
  COUNT(bytes_downloaded) / COUNT(*) AS bytes_downloaded_non_null_ratio,
  COUNT(default_path) / COUNT(*) AS default_path_non_null_ratio,
  COUNT(disk_space_error) / COUNT(*) AS disk_space_error_non_null_ratio,
  COUNT(disk_space_req_not_met) / COUNT(*) AS disk_space_req_not_met_non_null_ratio,
  COUNT(distribution_id) / COUNT(*) AS distribution_id_non_null_ratio,
  COUNT(distribution_version) / COUNT(*) AS distribution_version_non_null_ratio,
  COUNT(document_id) / COUNT(*) AS document_id_non_null_ratio,
  COUNT(download_ip) / COUNT(*) AS download_ip_non_null_ratio,
  COUNT(download_latency) / COUNT(*) AS download_latency_non_null_ratio,
  COUNT(download_retries) / COUNT(*) AS download_retries_non_null_ratio,
  COUNT(download_size) / COUNT(*) AS download_size_non_null_ratio,
  COUNT(download_time) / COUNT(*) AS download_time_non_null_ratio,
  COUNT(file_error) / COUNT(*) AS file_error_non_null_ratio,
  COUNT(finish_time) / COUNT(*) AS finish_time_non_null_ratio,
  COUNT(from_msi) / COUNT(*) AS from_msi_non_null_ratio,
  COUNT(funnelcake) / COUNT(*) AS funnelcake_non_null_ratio,
  COUNT(had_old_install) / COUNT(*) AS had_old_install_non_null_ratio,
  COUNT(hardware_req_not_met) / COUNT(*) AS hardware_req_not_met_non_null_ratio,
  COUNT(install_time) / COUNT(*) AS install_time_non_null_ratio,
  COUNT(install_timeout) / COUNT(*) AS install_timeout_non_null_ratio,
  COUNT(installer_type) / COUNT(*) AS installer_type_non_null_ratio,
  COUNT(installer_version) / COUNT(*) AS installer_version_non_null_ratio,
  COUNT(intro_time) / COUNT(*) AS intro_time_non_null_ratio,
  COUNT(locale) / COUNT(*) AS locale_non_null_ratio,
  COUNT(manual_download) / COUNT(*) AS manual_download_non_null_ratio,
  COUNT(new_default) / COUNT(*) AS new_default_non_null_ratio,
  COUNT(new_launched) / COUNT(*) AS new_launched_non_null_ratio,
  COUNT(no_write_access) / COUNT(*) AS no_write_access_non_null_ratio,
  COUNT(normalized_app_name) / COUNT(*) AS normalized_app_name_non_null_ratio,
  COUNT(normalized_channel) / COUNT(*) AS normalized_channel_non_null_ratio,
  COUNT(normalized_country_code) / COUNT(*) AS normalized_country_code_non_null_ratio,
  COUNT(normalized_os) / COUNT(*) AS normalized_os_non_null_ratio,
  COUNT(normalized_os_version) / COUNT(*) AS normalized_os_version_non_null_ratio,
  COUNT(old_build_id) / COUNT(*) AS old_build_id_non_null_ratio,
  COUNT(old_default) / COUNT(*) AS old_default_non_null_ratio,
  COUNT(old_running) / COUNT(*) AS old_running_non_null_ratio,
  COUNT(old_version) / COUNT(*) AS old_version_non_null_ratio,
  COUNT(options_time) / COUNT(*) AS options_time_non_null_ratio,
  COUNT(os_version) / COUNT(*) AS os_version_non_null_ratio,
  COUNT(os_version_req_not_met) / COUNT(*) AS os_version_req_not_met_non_null_ratio,
  COUNT(out_of_retries) / COUNT(*) AS out_of_retries_non_null_ratio,
  COUNT(ping_version) / COUNT(*) AS ping_version_non_null_ratio,
  COUNT(preinstall_time) / COUNT(*) AS preinstall_time_non_null_ratio,
  COUNT(profile_cleanup_prompt) / COUNT(*) AS profile_cleanup_prompt_non_null_ratio,
  COUNT(profile_cleanup_requested) / COUNT(*) AS profile_cleanup_requested_non_null_ratio,
  COUNT(sample_id) / COUNT(*) AS sample_id_non_null_ratio,
  COUNT(server_os) / COUNT(*) AS server_os_non_null_ratio,
  COUNT(service_pack) / COUNT(*) AS service_pack_non_null_ratio,
  COUNT(set_default) / COUNT(*) AS set_default_non_null_ratio,
  COUNT(sig_check_timeout) / COUNT(*) AS sig_check_timeout_non_null_ratio,
  COUNT(sig_not_trusted) / COUNT(*) AS sig_not_trusted_non_null_ratio,
  COUNT(sig_unexpected) / COUNT(*) AS sig_unexpected_non_null_ratio,
  COUNT(silent) / COUNT(*) AS silent_non_null_ratio,
  COUNT(stub_build_id) / COUNT(*) AS stub_build_id_non_null_ratio,
  COUNT(submission_timestamp) / COUNT(*) AS submission_timestamp_non_null_ratio,
  COUNT(succeeded) / COUNT(*) AS succeeded_non_null_ratio,
  COUNT(unknown_error) / COUNT(*) AS unknown_error_non_null_ratio,
  COUNT(update_channel) / COUNT(*) AS update_channel_non_null_ratio,
  COUNT(user_cancelled) / COUNT(*) AS user_cancelled_non_null_ratio,
  COUNT(version) / COUNT(*) AS version_non_null_ratio,
  COUNT(windows_ubr) / COUNT(*) AS windows_ubr_non_null_ratio,
  COUNT(writeable_req_not_met) / COUNT(*) AS writeable_req_not_met_non_null_ratio,
FROM
  `moz-fx-data-shared-prod.firefox_installer_live.install_v1`
WHERE
  DATE(submission_timestamp) = "2025-01-22"
  AND mozfun.norm.extract_version(  -- get only affected versions
    COALESCE(
      NULLIF(version, ""),
      NULLIF(installer_version, "")
    ),
    "major"
  ) >= 134
  AND ping_version IS NULL
UNION ALL
SELECT
  "stub_installer_backfill" AS source,
  COUNT(_64bit_build) / COUNT(*) AS _64bit_build_non_null_ratio,
  COUNT(_64bit_os) / COUNT(*) AS _64bit_os_non_null_ratio,
  COUNT(admin_user) / COUNT(*) AS admin_user_non_null_ratio,
  COUNT(attribution) / COUNT(*) AS attribution_non_null_ratio,
  COUNT(build_channel) / COUNT(*) AS build_channel_non_null_ratio,
  COUNT(build_id) / COUNT(*) AS build_id_non_null_ratio,
  COUNT(bytes_downloaded) / COUNT(*) AS bytes_downloaded_non_null_ratio,
  COUNT(default_path) / COUNT(*) AS default_path_non_null_ratio,
  COUNT(disk_space_error) / COUNT(*) AS disk_space_error_non_null_ratio,
  COUNT(disk_space_req_not_met) / COUNT(*) AS disk_space_req_not_met_non_null_ratio,
  COUNT(distribution_id) / COUNT(*) AS distribution_id_non_null_ratio,
  COUNT(distribution_version) / COUNT(*) AS distribution_version_non_null_ratio,
  COUNT(document_id) / COUNT(*) AS document_id_non_null_ratio,
  COUNT(download_ip) / COUNT(*) AS download_ip_non_null_ratio,
  COUNT(download_latency) / COUNT(*) AS download_latency_non_null_ratio,
  COUNT(download_retries) / COUNT(*) AS download_retries_non_null_ratio,
  COUNT(download_size) / COUNT(*) AS download_size_non_null_ratio,
  COUNT(download_time) / COUNT(*) AS download_time_non_null_ratio,
  COUNT(file_error) / COUNT(*) AS file_error_non_null_ratio,
  COUNT(finish_time) / COUNT(*) AS finish_time_non_null_ratio,
  COUNT(from_msi) / COUNT(*) AS from_msi_non_null_ratio,
  COUNT(funnelcake) / COUNT(*) AS funnelcake_non_null_ratio,
  COUNT(had_old_install) / COUNT(*) AS had_old_install_non_null_ratio,
  COUNT(hardware_req_not_met) / COUNT(*) AS hardware_req_not_met_non_null_ratio,
  COUNT(install_time) / COUNT(*) AS install_time_non_null_ratio,
  COUNT(install_timeout) / COUNT(*) AS install_timeout_non_null_ratio,
  COUNT(installer_type) / COUNT(*) AS installer_type_non_null_ratio,
  COUNT(installer_version) / COUNT(*) AS installer_version_non_null_ratio,
  COUNT(intro_time) / COUNT(*) AS intro_time_non_null_ratio,
  COUNT(locale) / COUNT(*) AS locale_non_null_ratio,
  COUNT(manual_download) / COUNT(*) AS manual_download_non_null_ratio,
  COUNT(new_default) / COUNT(*) AS new_default_non_null_ratio,
  COUNT(new_launched) / COUNT(*) AS new_launched_non_null_ratio,
  COUNT(no_write_access) / COUNT(*) AS no_write_access_non_null_ratio,
  COUNT(normalized_app_name) / COUNT(*) AS normalized_app_name_non_null_ratio,
  COUNT(normalized_channel) / COUNT(*) AS normalized_channel_non_null_ratio,
  COUNT(normalized_country_code) / COUNT(*) AS normalized_country_code_non_null_ratio,
  COUNT(normalized_os) / COUNT(*) AS normalized_os_non_null_ratio,
  COUNT(normalized_os_version) / COUNT(*) AS normalized_os_version_non_null_ratio,
  COUNT(old_build_id) / COUNT(*) AS old_build_id_non_null_ratio,
  COUNT(old_default) / COUNT(*) AS old_default_non_null_ratio,
  COUNT(old_running) / COUNT(*) AS old_running_non_null_ratio,
  COUNT(old_version) / COUNT(*) AS old_version_non_null_ratio,
  COUNT(options_time) / COUNT(*) AS options_time_non_null_ratio,
  COUNT(os_version) / COUNT(*) AS os_version_non_null_ratio,
  COUNT(os_version_req_not_met) / COUNT(*) AS os_version_req_not_met_non_null_ratio,
  COUNT(out_of_retries) / COUNT(*) AS out_of_retries_non_null_ratio,
  COUNT(ping_version) / COUNT(*) AS ping_version_non_null_ratio,
  COUNT(preinstall_time) / COUNT(*) AS preinstall_time_non_null_ratio,
  COUNT(profile_cleanup_prompt) / COUNT(*) AS profile_cleanup_prompt_non_null_ratio,
  COUNT(profile_cleanup_requested) / COUNT(*) AS profile_cleanup_requested_non_null_ratio,
  COUNT(sample_id) / COUNT(*) AS sample_id_non_null_ratio,
  COUNT(server_os) / COUNT(*) AS server_os_non_null_ratio,
  COUNT(service_pack) / COUNT(*) AS service_pack_non_null_ratio,
  COUNT(set_default) / COUNT(*) AS set_default_non_null_ratio,
  COUNT(sig_check_timeout) / COUNT(*) AS sig_check_timeout_non_null_ratio,
  COUNT(sig_not_trusted) / COUNT(*) AS sig_not_trusted_non_null_ratio,
  COUNT(sig_unexpected) / COUNT(*) AS sig_unexpected_non_null_ratio,
  COUNT(silent) / COUNT(*) AS silent_non_null_ratio,
  COUNT(stub_build_id) / COUNT(*) AS stub_build_id_non_null_ratio,
  COUNT(submission_timestamp) / COUNT(*) AS submission_timestamp_non_null_ratio,
  COUNT(succeeded) / COUNT(*) AS succeeded_non_null_ratio,
  COUNT(unknown_error) / COUNT(*) AS unknown_error_non_null_ratio,
  COUNT(update_channel) / COUNT(*) AS update_channel_non_null_ratio,
  COUNT(user_cancelled) / COUNT(*) AS user_cancelled_non_null_ratio,
  COUNT(version) / COUNT(*) AS version_non_null_ratio,
  COUNT(windows_ubr) / COUNT(*) AS windows_ubr_non_null_ratio,
  COUNT(writeable_req_not_met) / COUNT(*) AS writeable_req_not_met_non_null_ratio,
FROM
  `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
WHERE
  DATE(submission_timestamp) <= "2025-01-23"
  AND ping_version IS NOT NULL
UNION ALL
SELECT
  "stub_installer_existing" AS source,
  COUNT(_64bit_build) / COUNT(*) AS _64bit_build_non_null_ratio,
  COUNT(_64bit_os) / COUNT(*) AS _64bit_os_non_null_ratio,
  COUNT(admin_user) / COUNT(*) AS admin_user_non_null_ratio,
  COUNT(attribution) / COUNT(*) AS attribution_non_null_ratio,
  COUNT(build_channel) / COUNT(*) AS build_channel_non_null_ratio,
  COUNT(build_id) / COUNT(*) AS build_id_non_null_ratio,
  COUNT(bytes_downloaded) / COUNT(*) AS bytes_downloaded_non_null_ratio,
  COUNT(default_path) / COUNT(*) AS default_path_non_null_ratio,
  COUNT(disk_space_error) / COUNT(*) AS disk_space_error_non_null_ratio,
  COUNT(disk_space_req_not_met) / COUNT(*) AS disk_space_req_not_met_non_null_ratio,
  COUNT(distribution_id) / COUNT(*) AS distribution_id_non_null_ratio,
  COUNT(distribution_version) / COUNT(*) AS distribution_version_non_null_ratio,
  COUNT(document_id) / COUNT(*) AS document_id_non_null_ratio,
  COUNT(download_ip) / COUNT(*) AS download_ip_non_null_ratio,
  COUNT(download_latency) / COUNT(*) AS download_latency_non_null_ratio,
  COUNT(download_retries) / COUNT(*) AS download_retries_non_null_ratio,
  COUNT(download_size) / COUNT(*) AS download_size_non_null_ratio,
  COUNT(download_time) / COUNT(*) AS download_time_non_null_ratio,
  COUNT(file_error) / COUNT(*) AS file_error_non_null_ratio,
  COUNT(finish_time) / COUNT(*) AS finish_time_non_null_ratio,
  COUNT(from_msi) / COUNT(*) AS from_msi_non_null_ratio,
  COUNT(funnelcake) / COUNT(*) AS funnelcake_non_null_ratio,
  COUNT(had_old_install) / COUNT(*) AS had_old_install_non_null_ratio,
  COUNT(hardware_req_not_met) / COUNT(*) AS hardware_req_not_met_non_null_ratio,
  COUNT(install_time) / COUNT(*) AS install_time_non_null_ratio,
  COUNT(install_timeout) / COUNT(*) AS install_timeout_non_null_ratio,
  COUNT(installer_type) / COUNT(*) AS installer_type_non_null_ratio,
  COUNT(installer_version) / COUNT(*) AS installer_version_non_null_ratio,
  COUNT(intro_time) / COUNT(*) AS intro_time_non_null_ratio,
  COUNT(locale) / COUNT(*) AS locale_non_null_ratio,
  COUNT(manual_download) / COUNT(*) AS manual_download_non_null_ratio,
  COUNT(new_default) / COUNT(*) AS new_default_non_null_ratio,
  COUNT(new_launched) / COUNT(*) AS new_launched_non_null_ratio,
  COUNT(no_write_access) / COUNT(*) AS no_write_access_non_null_ratio,
  COUNT(normalized_app_name) / COUNT(*) AS normalized_app_name_non_null_ratio,
  COUNT(normalized_channel) / COUNT(*) AS normalized_channel_non_null_ratio,
  COUNT(normalized_country_code) / COUNT(*) AS normalized_country_code_non_null_ratio,
  COUNT(normalized_os) / COUNT(*) AS normalized_os_non_null_ratio,
  COUNT(normalized_os_version) / COUNT(*) AS normalized_os_version_non_null_ratio,
  COUNT(old_build_id) / COUNT(*) AS old_build_id_non_null_ratio,
  COUNT(old_default) / COUNT(*) AS old_default_non_null_ratio,
  COUNT(old_running) / COUNT(*) AS old_running_non_null_ratio,
  COUNT(old_version) / COUNT(*) AS old_version_non_null_ratio,
  COUNT(options_time) / COUNT(*) AS options_time_non_null_ratio,
  COUNT(os_version) / COUNT(*) AS os_version_non_null_ratio,
  COUNT(os_version_req_not_met) / COUNT(*) AS os_version_req_not_met_non_null_ratio,
  COUNT(out_of_retries) / COUNT(*) AS out_of_retries_non_null_ratio,
  COUNT(ping_version) / COUNT(*) AS ping_version_non_null_ratio,
  COUNT(preinstall_time) / COUNT(*) AS preinstall_time_non_null_ratio,
  COUNT(profile_cleanup_prompt) / COUNT(*) AS profile_cleanup_prompt_non_null_ratio,
  COUNT(profile_cleanup_requested) / COUNT(*) AS profile_cleanup_requested_non_null_ratio,
  COUNT(sample_id) / COUNT(*) AS sample_id_non_null_ratio,
  COUNT(server_os) / COUNT(*) AS server_os_non_null_ratio,
  COUNT(service_pack) / COUNT(*) AS service_pack_non_null_ratio,
  COUNT(set_default) / COUNT(*) AS set_default_non_null_ratio,
  COUNT(sig_check_timeout) / COUNT(*) AS sig_check_timeout_non_null_ratio,
  COUNT(sig_not_trusted) / COUNT(*) AS sig_not_trusted_non_null_ratio,
  COUNT(sig_unexpected) / COUNT(*) AS sig_unexpected_non_null_ratio,
  COUNT(silent) / COUNT(*) AS silent_non_null_ratio,
  COUNT(stub_build_id) / COUNT(*) AS stub_build_id_non_null_ratio,
  COUNT(submission_timestamp) / COUNT(*) AS submission_timestamp_non_null_ratio,
  COUNT(succeeded) / COUNT(*) AS succeeded_non_null_ratio,
  COUNT(unknown_error) / COUNT(*) AS unknown_error_non_null_ratio,
  COUNT(update_channel) / COUNT(*) AS update_channel_non_null_ratio,
  COUNT(user_cancelled) / COUNT(*) AS user_cancelled_non_null_ratio,
  COUNT(version) / COUNT(*) AS version_non_null_ratio,
  COUNT(windows_ubr) / COUNT(*) AS windows_ubr_non_null_ratio,
  COUNT(writeable_req_not_met) / COUNT(*) AS writeable_req_not_met_non_null_ratio,
FROM
  `moz-fx-data-shared-prod.firefox_installer_live.install_v1`
WHERE
  DATE(submission_timestamp) = "2025-01-22"
  AND mozfun.norm.extract_version(  -- get only affected versions
    COALESCE(
      NULLIF(version, ""),
      NULLIF(installer_version, "")
    ),
    "major"
  ) >= 134
  AND ping_version IS NOT NULL

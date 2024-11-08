
        INSERT INTO
          `moz-fx-data-shared-prod.firefox_desktop_stable.metrics_v1`
        additional_properties, 
                                STRUCT(
                                    client_info.android_sdk_version, client_info.app_build, client_info.app_channel, client_info.app_display_version, client_info.architecture, client_info.client_id, client_info.device_manufacturer, client_info.device_model, client_info.first_run_date, client_info.locale, client_info.os, client_info.os_version, client_info.telemetry_sdk_build, client_info.build_date, client_info.windows_build_number, client_info.session_count, client_info.session_id
                                ) AS `client_info`
                            , document_id, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            events.category, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            extra.key, extra.value
                                        )
                                    FROM UNNEST(events.extra) AS `extra`
                                ) AS `extra`
                            , events.name, events.timestamp
                                        )
                                    FROM UNNEST(events) AS `events`
                                ) AS `events`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metadata.geo.city, metadata.geo.country, metadata.geo.db_version, metadata.geo.subdivision1, metadata.geo.subdivision2
                                ) AS `geo`
                            , 
                                STRUCT(
                                    metadata.header.date, metadata.header.dnt, metadata.header.x_debug_id, metadata.header.x_pingsender_version, metadata.header.x_source_tags, metadata.header.x_telemetry_agent, metadata.header.x_foxsec_ip_reputation, metadata.header.x_lb_tags
                                ) AS `header`
                            , 
                                STRUCT(
                                    metadata.isp.db_version, metadata.isp.name, metadata.isp.organization
                                ) AS `isp`
                            , 
                                STRUCT(
                                    metadata.user_agent.browser, metadata.user_agent.os, metadata.user_agent.version
                                ) AS `user_agent`
                            
                                ) AS `metadata`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metrics.boolean.glean_core_migration_successful, metrics.boolean.glean_error_preinit_tasks_timeout, metrics.boolean.fog_failed_idle_registration, metrics.boolean.browser_ui_proton_enabled, metrics.boolean.gifft_validation_main_ping_assembling, metrics.boolean.cookie_banners_service_detect_only, metrics.boolean.startup_is_restored_by_macos, metrics.boolean.shopping_settings_component_opted_out, metrics.boolean.shopping_settings_has_onboarded, metrics.boolean.shopping_settings_nimbus_disabled_shopping, metrics.boolean.extensions_use_remote_policy, metrics.boolean.extensions_use_remote_pref, metrics.boolean.newtab_handoff_preference_enabled, metrics.boolean.shopping_settings_disabled_ads, metrics.boolean.gfx_status_headless, metrics.boolean.shopping_settings_auto_open_user_disabled, metrics.boolean.bounce_tracking_protection_enabled_at_startup, metrics.boolean.bounce_tracking_protection_enabled_dry_run_mode_at_startup, metrics.boolean.installation_first_seen_admin_user, metrics.boolean.installation_first_seen_default_path, metrics.boolean.installation_first_seen_from_msi, metrics.boolean.installation_first_seen_install_existed, metrics.boolean.installation_first_seen_other_inst, metrics.boolean.installation_first_seen_other_msix_inst, metrics.boolean.installation_first_seen_profdir_existed, metrics.boolean.installation_first_seen_silent, metrics.boolean.genai_chatbot_enabled, metrics.boolean.genai_chatbot_sidebar, metrics.boolean.genai_chatbot_shortcuts, metrics.boolean.genai_chatbot_shortcuts_custom, metrics.boolean.sslkeylogging_enabled, metrics.boolean.a11y_always_underline_links, metrics.boolean.a11y_backplate, metrics.boolean.a11y_invert_colors, metrics.boolean.a11y_use_system_colors, metrics.boolean.browser_startup_abouthome_cache_shutdownwrite, metrics.boolean.datasanitization_privacy_clear_on_shutdown_cache, metrics.boolean.datasanitization_privacy_clear_on_shutdown_cookies, metrics.boolean.datasanitization_privacy_clear_on_shutdown_downloads, metrics.boolean.datasanitization_privacy_clear_on_shutdown_formdata, metrics.boolean.datasanitization_privacy_clear_on_shutdown_history, metrics.boolean.datasanitization_privacy_clear_on_shutdown_offline_apps, metrics.boolean.datasanitization_privacy_clear_on_shutdown_open_windows, metrics.boolean.datasanitization_privacy_clear_on_shutdown_sessions, metrics.boolean.datasanitization_privacy_clear_on_shutdown_site_settings, metrics.boolean.datasanitization_privacy_sanitize_sanitize_on_shutdown, metrics.boolean.gfx_os_compositor, metrics.boolean.gfx_supports_hdr, metrics.boolean.gfx_tmp_writable, metrics.boolean.preferences_prefs_file_was_invalid, metrics.boolean.networking_http3_enabled, metrics.boolean.migration_uninstaller_profile_refresh, metrics.boolean.os_environment_is_admin_without_uac, metrics.boolean.os_environment_is_kept_in_dock, metrics.boolean.os_environment_is_taskbar_pinned, metrics.boolean.os_environment_is_taskbar_pinned_private, metrics.boolean.pictureinpicture_toggle_enabled, metrics.boolean.startup_is_cold, metrics.boolean.telemetry_data_upload_optin, metrics.boolean.contentblocking_cryptomining_blocking_enabled, metrics.boolean.contentblocking_fingerprinting_blocking_enabled, metrics.boolean.policies_is_enterprise, metrics.boolean.widget_dark_mode, metrics.boolean.dom_parentprocess_private_window_used, metrics.boolean.browser_backup_enabled, metrics.boolean.browser_backup_pswd_encrypted, metrics.boolean.browser_backup_scheduler_enabled
                                ) AS `boolean`
                            , 
                                STRUCT(
                                    metrics.counter.glean_error_preinit_tasks_overflow, metrics.counter.glean_validation_app_forceclosed_count, metrics.counter.glean_validation_baseline_ping_count, metrics.counter.glean_upload_deleted_pings_after_quota_hit, metrics.counter.glean_upload_pending_pings, metrics.counter.fog_ipc_replay_failures, metrics.counter.glean_validation_foreground_count, metrics.counter.glean_error_io, metrics.counter.glean_time_invalid_timezone_offset, metrics.counter.power_total_cpu_time_ms, metrics.counter.browser_engagement_active_ticks, metrics.counter.browser_engagement_uri_count, metrics.counter.fog_ipc_flush_failures, metrics.counter.power_total_gpu_time_ms, metrics.counter.power_cpu_time_bogus_values, metrics.counter.power_gpu_time_bogus_values, metrics.counter.power_total_thread_wakeups, metrics.counter.fog_ipc_shutdown_registration_failures, metrics.counter.ping_centre_send_failures, metrics.counter.pdfjs_used, metrics.counter.rtcrtpsender_count, metrics.counter.rtcrtpsender_count_setparameters_compat, metrics.counter.glean_upload_in_flight_pings_dropped, metrics.counter.glean_upload_missing_send_ids, metrics.counter.dotprint_requested, metrics.counter.dotprint_android_dialog_requested, metrics.counter.messaging_system_glean_ping_for_ping_failures, metrics.counter.translations_requests_count, metrics.counter.fog_inits_during_shutdown, metrics.counter.bloburl_resolve_stopped, metrics.counter.shopping_product_page_visits, metrics.counter.networking_residual_cache_folder_count, metrics.counter.cookie_banners_cookie_injection_fail, metrics.counter.networking_set_cookie, metrics.counter.tls_certificate_verifications, metrics.counter.pdfjs_editing_highlight_color_changed, metrics.counter.pdfjs_editing_highlight_deleted, metrics.counter.pdfjs_editing_highlight_edited, metrics.counter.pdfjs_editing_highlight_print, metrics.counter.pdfjs_editing_highlight_save, metrics.counter.pdfjs_editing_highlight_thickness_changed, metrics.counter.pdfjs_editing_highlight_toggle_visibility, metrics.counter.httpsfirst_downgraded, metrics.counter.httpsfirst_downgraded_schemeless, metrics.counter.httpsfirst_upgraded, metrics.counter.httpsfirst_upgraded_schemeless, metrics.counter.hls_canplay_requested, metrics.counter.hls_canplay_supported, metrics.counter.bounce_tracking_protection_purge_count_classified_tracker, metrics.counter.webauthn_create_failure, metrics.counter.webauthn_create_passkey, metrics.counter.webauthn_create_success, metrics.counter.webauthn_get_failure, metrics.counter.webauthn_get_success, metrics.counter.crash_submission_failure, metrics.counter.crash_submission_pending, metrics.counter.crash_submission_success, metrics.counter.netwerk_parent_connect_timeout, metrics.counter.networking_os_socket_limit_reached, metrics.counter.page_icon_fit_icon_count, metrics.counter.page_icon_small_icon_count, metrics.counter.web_notification_insecure_context_permission_request, metrics.counter.cert_signature_cache_total, metrics.counter.sct_signature_cache_total, metrics.counter.webrtcdtls_client_handshake_started_counter, metrics.counter.webrtcdtls_server_handshake_started_counter, metrics.counter.ls_request_recv_cancellation, metrics.counter.ls_request_send_cancellation, metrics.counter.apz_scrollwheel_overshoot, metrics.counter.downloads_file_opened, metrics.counter.downloads_panel_shown, metrics.counter.findbar_find_next, metrics.counter.findbar_find_prev, metrics.counter.findbar_highlight_all, metrics.counter.findbar_match_case, metrics.counter.findbar_match_diacritics, metrics.counter.findbar_shown, metrics.counter.findbar_whole_words, metrics.counter.gfx_skipped_composites, metrics.counter.media_element_in_page_count, metrics.counter.networking_doh_heuristics_attempts, metrics.counter.networking_doh_heuristics_pass_count, metrics.counter.opaque_response_blocking_cross_origin_opaque_response_count, metrics.counter.opaque_response_blocking_javascript_validation_count, metrics.counter.places_sponsored_visit_no_triggering_url, metrics.counter.cert_trust_cache_total, metrics.counter.contentblocking_trackers_blocked_count, metrics.counter.networking_cookie_count_invalid_first_party_partitioned_in_db, metrics.counter.networking_set_invalid_first_party_partitioned_cookie, metrics.counter.printing_dialog_opened_via_preview_tm, metrics.counter.printing_dialog_via_preview_cancelled_tm, metrics.counter.printing_preview_cancelled_tm, metrics.counter.printing_preview_opened_tm, metrics.counter.printing_silent_print, metrics.counter.browser_engagement_uri_count_normal_mode, metrics.counter.dom_contentprocess_build_id_mismatch, metrics.counter.dom_contentprocess_build_id_mismatch_false_positive, metrics.counter.dom_contentprocess_os_priority_change_considered, metrics.counter.dom_contentprocess_os_priority_lowered, metrics.counter.dom_contentprocess_os_priority_raised, metrics.counter.mathml_doc_count, metrics.counter.browser_ui_interaction_all_tabs_panel_dragstart_tab_event_count, metrics.counter.browser_ui_interaction_textrecognition_error, metrics.counter.web_push_detected_duplicated_message_ids, metrics.counter.browser_engagement_bookmarks_toolbar_bookmark_added, metrics.counter.browser_engagement_bookmarks_toolbar_bookmark_opened, metrics.counter.browser_engagement_tab_open_event_count, metrics.counter.browser_engagement_tab_pinned_event_count, metrics.counter.browser_engagement_tab_reload_count, metrics.counter.browser_engagement_tab_unload_count, metrics.counter.browser_engagement_unfiltered_uri_count, metrics.counter.browser_engagement_vertical_tab_open_event_count, metrics.counter.browser_engagement_vertical_tab_pinned_event_count, metrics.counter.browser_engagement_window_open_event_count, metrics.counter.urlbar_abandonment_count, metrics.counter.urlbar_autofill_deletion, metrics.counter.urlbar_engagement_count, metrics.counter.urlbar_impression_autofill_about, metrics.counter.urlbar_impression_autofill_adaptive, metrics.counter.urlbar_impression_autofill_origin, metrics.counter.urlbar_impression_autofill_other, metrics.counter.urlbar_impression_autofill_url, metrics.counter.urlbar_persistedsearchterms_revert_by_popup_count, metrics.counter.urlbar_persistedsearchterms_view_count, metrics.counter.urlbar_trending_block, metrics.counter.urlbar_zeroprefix_abandonment, metrics.counter.urlbar_zeroprefix_engagement, metrics.counter.urlbar_zeroprefix_exposure
                                ) AS `counter`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            jwe.key, jwe.value
                                        )
                                    FROM UNNEST(metrics.jwe) AS `jwe`
                                ) AS `jwe`
                            , 
                                STRUCT(
                                    
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            glean_error_invalid_label.key, glean_error_invalid_label.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.glean_error_invalid_label) AS `glean_error_invalid_label`
                                ) AS `glean_error_invalid_label`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            glean_error_invalid_overflow.key, glean_error_invalid_overflow.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.glean_error_invalid_overflow) AS `glean_error_invalid_overflow`
                                ) AS `glean_error_invalid_overflow`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            glean_error_invalid_state.key, glean_error_invalid_state.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.glean_error_invalid_state) AS `glean_error_invalid_state`
                                ) AS `glean_error_invalid_state`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            glean_error_invalid_value.key, glean_error_invalid_value.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.glean_error_invalid_value) AS `glean_error_invalid_value`
                                ) AS `glean_error_invalid_value`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            glean_upload_ping_upload_failure.key, glean_upload_ping_upload_failure.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.glean_upload_ping_upload_failure) AS `glean_upload_ping_upload_failure`
                                ) AS `glean_upload_ping_upload_failure`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            glean_validation_pings_submitted.key, glean_validation_pings_submitted.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.glean_validation_pings_submitted) AS `glean_validation_pings_submitted`
                                ) AS `glean_validation_pings_submitted`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_time_per_process_type_ms.key, power_cpu_time_per_process_type_ms.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_time_per_process_type_ms) AS `power_cpu_time_per_process_type_ms`
                                ) AS `power_cpu_time_per_process_type_ms`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_gpu_time_per_process_type_ms.key, power_gpu_time_per_process_type_ms.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_gpu_time_per_process_type_ms) AS `power_gpu_time_per_process_type_ms`
                                ) AS `power_gpu_time_per_process_type_ms`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_wakeups_per_process_type.key, power_wakeups_per_process_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_wakeups_per_process_type) AS `power_wakeups_per_process_type`
                                ) AS `power_wakeups_per_process_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            gmp_update_xml_fetch_result.key, gmp_update_xml_fetch_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.gmp_update_xml_fetch_result) AS `gmp_update_xml_fetch_result`
                                ) AS `gmp_update_xml_fetch_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_ms_per_thread_content_background.key, power_cpu_ms_per_thread_content_background.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_ms_per_thread_content_background) AS `power_cpu_ms_per_thread_content_background`
                                ) AS `power_cpu_ms_per_thread_content_background`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_ms_per_thread_content_foreground.key, power_cpu_ms_per_thread_content_foreground.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_ms_per_thread_content_foreground) AS `power_cpu_ms_per_thread_content_foreground`
                                ) AS `power_cpu_ms_per_thread_content_foreground`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_ms_per_thread_gpu_process.key, power_cpu_ms_per_thread_gpu_process.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_ms_per_thread_gpu_process) AS `power_cpu_ms_per_thread_gpu_process`
                                ) AS `power_cpu_ms_per_thread_gpu_process`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_ms_per_thread_parent_active.key, power_cpu_ms_per_thread_parent_active.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_ms_per_thread_parent_active) AS `power_cpu_ms_per_thread_parent_active`
                                ) AS `power_cpu_ms_per_thread_parent_active`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_ms_per_thread_parent_inactive.key, power_cpu_ms_per_thread_parent_inactive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_ms_per_thread_parent_inactive) AS `power_cpu_ms_per_thread_parent_inactive`
                                ) AS `power_cpu_ms_per_thread_parent_inactive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_wakeups_per_thread_content_background.key, power_wakeups_per_thread_content_background.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_wakeups_per_thread_content_background) AS `power_wakeups_per_thread_content_background`
                                ) AS `power_wakeups_per_thread_content_background`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_wakeups_per_thread_content_foreground.key, power_wakeups_per_thread_content_foreground.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_wakeups_per_thread_content_foreground) AS `power_wakeups_per_thread_content_foreground`
                                ) AS `power_wakeups_per_thread_content_foreground`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_wakeups_per_thread_gpu_process.key, power_wakeups_per_thread_gpu_process.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_wakeups_per_thread_gpu_process) AS `power_wakeups_per_thread_gpu_process`
                                ) AS `power_wakeups_per_thread_gpu_process`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_wakeups_per_thread_parent_active.key, power_wakeups_per_thread_parent_active.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_wakeups_per_thread_parent_active) AS `power_wakeups_per_thread_parent_active`
                                ) AS `power_wakeups_per_thread_parent_active`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_wakeups_per_thread_parent_inactive.key, power_wakeups_per_thread_parent_inactive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_wakeups_per_thread_parent_inactive) AS `power_wakeups_per_thread_parent_inactive`
                                ) AS `power_wakeups_per_thread_parent_inactive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_early_hints.key, netwerk_early_hints.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_early_hints) AS `netwerk_early_hints`
                                ) AS `netwerk_early_hints`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_editing.key, pdfjs_editing.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_editing) AS `pdfjs_editing`
                                ) AS `pdfjs_editing`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_buttons.key, pdfjs_buttons.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_buttons) AS `pdfjs_buttons`
                                ) AS `pdfjs_buttons`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            dap_report_generation_status.key, dap_report_generation_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.dap_report_generation_status) AS `dap_report_generation_status`
                                ) AS `dap_report_generation_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            dap_upload_status.key, dap_upload_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.dap_upload_status) AS `dap_upload_status`
                                ) AS `dap_upload_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_eh_link_type.key, netwerk_eh_link_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_eh_link_type) AS `netwerk_eh_link_type`
                                ) AS `netwerk_eh_link_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_click_result.key, cookie_banners_click_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cookie_banners_click_result) AS `cookie_banners_click_result`
                                ) AS `cookie_banners_click_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_cpu_time_per_tracker_type_ms.key, power_cpu_time_per_tracker_type_ms.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_cpu_time_per_tracker_type_ms) AS `power_cpu_time_per_tracker_type_ms`
                                ) AS `power_cpu_time_per_tracker_type_ms`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_received_messages_content_background.key, ipc_received_messages_content_background.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_received_messages_content_background) AS `ipc_received_messages_content_background`
                                ) AS `ipc_received_messages_content_background`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_received_messages_content_foreground.key, ipc_received_messages_content_foreground.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_received_messages_content_foreground) AS `ipc_received_messages_content_foreground`
                                ) AS `ipc_received_messages_content_foreground`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_received_messages_gpu_process.key, ipc_received_messages_gpu_process.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_received_messages_gpu_process) AS `ipc_received_messages_gpu_process`
                                ) AS `ipc_received_messages_gpu_process`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_received_messages_parent_active.key, ipc_received_messages_parent_active.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_received_messages_parent_active) AS `ipc_received_messages_parent_active`
                                ) AS `ipc_received_messages_parent_active`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_received_messages_parent_inactive.key, ipc_received_messages_parent_inactive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_received_messages_parent_inactive) AS `ipc_received_messages_parent_inactive`
                                ) AS `ipc_received_messages_parent_inactive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_sent_messages_content_background.key, ipc_sent_messages_content_background.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_sent_messages_content_background) AS `ipc_sent_messages_content_background`
                                ) AS `ipc_sent_messages_content_background`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_sent_messages_content_foreground.key, ipc_sent_messages_content_foreground.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_sent_messages_content_foreground) AS `ipc_sent_messages_content_foreground`
                                ) AS `ipc_sent_messages_content_foreground`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_sent_messages_gpu_process.key, ipc_sent_messages_gpu_process.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_sent_messages_gpu_process) AS `ipc_sent_messages_gpu_process`
                                ) AS `ipc_sent_messages_gpu_process`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_sent_messages_parent_active.key, ipc_sent_messages_parent_active.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_sent_messages_parent_active) AS `ipc_sent_messages_parent_active`
                                ) AS `ipc_sent_messages_parent_active`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ipc_sent_messages_parent_inactive.key, ipc_sent_messages_parent_inactive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ipc_sent_messages_parent_inactive) AS `ipc_sent_messages_parent_inactive`
                                ) AS `ipc_sent_messages_parent_inactive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_rule_lookup_by_domain.key, cookie_banners_rule_lookup_by_domain.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cookie_banners_rule_lookup_by_domain) AS `cookie_banners_rule_lookup_by_domain`
                                ) AS `cookie_banners_rule_lookup_by_domain`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_rule_lookup_by_load.key, cookie_banners_rule_lookup_by_load.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cookie_banners_rule_lookup_by_load) AS `cookie_banners_rule_lookup_by_load`
                                ) AS `cookie_banners_rule_lookup_by_load`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ping_centre_send_failures_by_namespace.key, ping_centre_send_failures_by_namespace.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ping_centre_send_failures_by_namespace) AS `ping_centre_send_failures_by_namespace`
                                ) AS `ping_centre_send_failures_by_namespace`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            ping_centre_send_successes_by_namespace.key, ping_centre_send_successes_by_namespace.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.ping_centre_send_successes_by_namespace) AS `ping_centre_send_successes_by_namespace`
                                ) AS `ping_centre_send_successes_by_namespace`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_data_size_pb_per_type.key, network_data_size_pb_per_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_data_size_pb_per_type) AS `network_data_size_pb_per_type`
                                ) AS `network_data_size_pb_per_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_data_size_per_type.key, network_data_size_per_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_data_size_per_type) AS `network_data_size_per_type`
                                ) AS `network_data_size_per_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_speculative_connection_outcome.key, networking_speculative_connection_outcome.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_speculative_connection_outcome) AS `networking_speculative_connection_outcome`
                                ) AS `networking_speculative_connection_outcome`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_speculative_connect_outcome.key, networking_speculative_connect_outcome.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_speculative_connect_outcome) AS `networking_speculative_connect_outcome`
                                ) AS `networking_speculative_connect_outcome`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            extensions_apis_dnr_startup_cache_entries.key, extensions_apis_dnr_startup_cache_entries.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.extensions_apis_dnr_startup_cache_entries) AS `extensions_apis_dnr_startup_cache_entries`
                                ) AS `extensions_apis_dnr_startup_cache_entries`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_cookie_timestamp_fixed_count.key, networking_cookie_timestamp_fixed_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_cookie_timestamp_fixed_count) AS `networking_cookie_timestamp_fixed_count`
                                ) AS `networking_cookie_timestamp_fixed_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            rtcrtpsender_setparameters_blame_length_changed.key, rtcrtpsender_setparameters_blame_length_changed.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.rtcrtpsender_setparameters_blame_length_changed) AS `rtcrtpsender_setparameters_blame_length_changed`
                                ) AS `rtcrtpsender_setparameters_blame_length_changed`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            rtcrtpsender_setparameters_blame_no_getparameters.key, rtcrtpsender_setparameters_blame_no_getparameters.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.rtcrtpsender_setparameters_blame_no_getparameters) AS `rtcrtpsender_setparameters_blame_no_getparameters`
                                ) AS `rtcrtpsender_setparameters_blame_no_getparameters`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            rtcrtpsender_setparameters_blame_no_transactionid.key, rtcrtpsender_setparameters_blame_no_transactionid.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.rtcrtpsender_setparameters_blame_no_transactionid) AS `rtcrtpsender_setparameters_blame_no_transactionid`
                                ) AS `rtcrtpsender_setparameters_blame_no_transactionid`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            rtcrtpsender_setparameters_blame_stale_transactionid.key, rtcrtpsender_setparameters_blame_stale_transactionid.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.rtcrtpsender_setparameters_blame_stale_transactionid) AS `rtcrtpsender_setparameters_blame_stale_transactionid`
                                ) AS `rtcrtpsender_setparameters_blame_stale_transactionid`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            dotprint_failure.key, dotprint_failure.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.dotprint_failure) AS `dotprint_failure`
                                ) AS `dotprint_failure`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_geckoview.key, pdfjs_geckoview.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_geckoview) AS `pdfjs_geckoview`
                                ) AS `pdfjs_geckoview`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            messaging_system_invalid_nested_data.key, messaging_system_invalid_nested_data.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.messaging_system_invalid_nested_data) AS `messaging_system_invalid_nested_data`
                                ) AS `messaging_system_invalid_nested_data`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_cors_authorization_header.key, network_cors_authorization_header.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_cors_authorization_header) AS `network_cors_authorization_header`
                                ) AS `network_cors_authorization_header`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pwmgr_form_autofill_result.key, pwmgr_form_autofill_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pwmgr_form_autofill_result) AS `pwmgr_form_autofill_result`
                                ) AS `pwmgr_form_autofill_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            extensions_process_event.key, extensions_process_event.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.extensions_process_event) AS `extensions_process_event`
                                ) AS `extensions_process_event`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            data_storage_entries.key, data_storage_entries.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.data_storage_entries) AS `data_storage_entries`
                                ) AS `data_storage_entries`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_stamp.key, pdfjs_stamp.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_stamp) AS `pdfjs_stamp`
                                ) AS `pdfjs_stamp`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            fog_validation_gvsv_audio_stream_init.key, fog_validation_gvsv_audio_stream_init.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.fog_validation_gvsv_audio_stream_init) AS `fog_validation_gvsv_audio_stream_init`
                                ) AS `fog_validation_gvsv_audio_stream_init`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            fog_validation_gvsv_audio_stream_init_gecko.key, fog_validation_gvsv_audio_stream_init_gecko.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.fog_validation_gvsv_audio_stream_init_gecko) AS `fog_validation_gvsv_audio_stream_init_gecko`
                                ) AS `fog_validation_gvsv_audio_stream_init_gecko`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            search_service_initialization_status.key, search_service_initialization_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.search_service_initialization_status) AS `search_service_initialization_status`
                                ) AS `search_service_initialization_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            extensions_counters_browser_action_preload_result.key, extensions_counters_browser_action_preload_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.extensions_counters_browser_action_preload_result) AS `extensions_counters_browser_action_preload_result`
                                ) AS `extensions_counters_browser_action_preload_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            extensions_counters_event_page_idle_result.key, extensions_counters_event_page_idle_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.extensions_counters_event_page_idle_result) AS `extensions_counters_event_page_idle_result`
                                ) AS `extensions_counters_event_page_idle_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            protocolhandler_mailto_handler_prompt_shown.key, protocolhandler_mailto_handler_prompt_shown.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.protocolhandler_mailto_handler_prompt_shown) AS `protocolhandler_mailto_handler_prompt_shown`
                                ) AS `protocolhandler_mailto_handler_prompt_shown`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            protocolhandler_mailto_prompt_clicked.key, protocolhandler_mailto_prompt_clicked.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.protocolhandler_mailto_prompt_clicked) AS `protocolhandler_mailto_prompt_clicked`
                                ) AS `protocolhandler_mailto_prompt_clicked`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_residual_cache_folder_removal.key, networking_residual_cache_folder_removal.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_residual_cache_folder_removal) AS `networking_residual_cache_folder_removal`
                                ) AS `networking_residual_cache_folder_removal`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_cmp_detected_cmp.key, cookie_banners_cmp_detected_cmp.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cookie_banners_cmp_detected_cmp) AS `cookie_banners_cmp_detected_cmp`
                                ) AS `cookie_banners_cmp_detected_cmp`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_cmp_result.key, cookie_banners_cmp_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cookie_banners_cmp_result) AS `cookie_banners_cmp_result`
                                ) AS `cookie_banners_cmp_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            extensions_startup_cache_read_errors.key, extensions_startup_cache_read_errors.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.extensions_startup_cache_read_errors) AS `extensions_startup_cache_read_errors`
                                ) AS `extensions_startup_cache_read_errors`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_trr_request_count.key, networking_trr_request_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_trr_request_count) AS `networking_trr_request_count`
                                ) AS `networking_trr_request_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            codec_stats_audio_preferred_codec.key, codec_stats_audio_preferred_codec.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.codec_stats_audio_preferred_codec) AS `codec_stats_audio_preferred_codec`
                                ) AS `codec_stats_audio_preferred_codec`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            codec_stats_other_fec_signaled.key, codec_stats_other_fec_signaled.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.codec_stats_other_fec_signaled) AS `codec_stats_other_fec_signaled`
                                ) AS `codec_stats_other_fec_signaled`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            codec_stats_ulpfec_negotiated.key, codec_stats_ulpfec_negotiated.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.codec_stats_ulpfec_negotiated) AS `codec_stats_ulpfec_negotiated`
                                ) AS `codec_stats_ulpfec_negotiated`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            codec_stats_video_preferred_codec.key, codec_stats_video_preferred_codec.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.codec_stats_video_preferred_codec) AS `codec_stats_video_preferred_codec`
                                ) AS `codec_stats_video_preferred_codec`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            gpu_process_crash_fallbacks.key, gpu_process_crash_fallbacks.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.gpu_process_crash_fallbacks) AS `gpu_process_crash_fallbacks`
                                ) AS `gpu_process_crash_fallbacks`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            formautofill_form_submission_heuristic.key, formautofill_form_submission_heuristic.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.formautofill_form_submission_heuristic) AS `formautofill_form_submission_heuristic`
                                ) AS `formautofill_form_submission_heuristic`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_onstart_success_https_rr.key, networking_http_channel_onstart_success_https_rr.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_onstart_success_https_rr) AS `networking_http_channel_onstart_success_https_rr`
                                ) AS `networking_http_channel_onstart_success_https_rr`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_https_rr_presented.key, networking_https_rr_presented.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_https_rr_presented) AS `networking_https_rr_presented`
                                ) AS `networking_https_rr_presented`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_https_upgrade_with_https_rr.key, networking_https_upgrade_with_https_rr.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_https_upgrade_with_https_rr) AS `networking_https_upgrade_with_https_rr`
                                ) AS `networking_https_upgrade_with_https_rr`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            gfx_content_frame_time_reason.key, gfx_content_frame_time_reason.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.gfx_content_frame_time_reason) AS `gfx_content_frame_time_reason`
                                ) AS `gfx_content_frame_time_reason`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_dns_native_count.key, networking_dns_native_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_dns_native_count) AS `networking_dns_native_count`
                                ) AS `networking_dns_native_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_response_version.key, networking_http_response_version.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_response_version) AS `networking_http_response_version`
                                ) AS `networking_http_response_version`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            tls_xyber_intolerance_reason.key, tls_xyber_intolerance_reason.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.tls_xyber_intolerance_reason) AS `tls_xyber_intolerance_reason`
                                ) AS `tls_xyber_intolerance_reason`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_audio_backend.key, media_audio_backend.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.media_audio_backend) AS `media_audio_backend`
                                ) AS `media_audio_backend`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_audio_init_failure.key, media_audio_init_failure.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.media_audio_init_failure) AS `media_audio_init_failure`
                                ) AS `media_audio_init_failure`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_a1lx.key, avif_a1lx.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_a1lx) AS `avif_a1lx`
                                ) AS `avif_a1lx`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_a1op.key, avif_a1op.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_a1op) AS `avif_a1op`
                                ) AS `avif_a1op`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_alpha.key, avif_alpha.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_alpha) AS `avif_alpha`
                                ) AS `avif_alpha`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_aom_decode_error.key, avif_aom_decode_error.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_aom_decode_error) AS `avif_aom_decode_error`
                                ) AS `avif_aom_decode_error`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_bit_depth.key, avif_bit_depth.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_bit_depth) AS `avif_bit_depth`
                                ) AS `avif_bit_depth`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_cicp_cp.key, avif_cicp_cp.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_cicp_cp) AS `avif_cicp_cp`
                                ) AS `avif_cicp_cp`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_cicp_mc.key, avif_cicp_mc.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_cicp_mc) AS `avif_cicp_mc`
                                ) AS `avif_cicp_mc`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_cicp_tc.key, avif_cicp_tc.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_cicp_tc) AS `avif_cicp_tc`
                                ) AS `avif_cicp_tc`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_clap.key, avif_clap.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_clap) AS `avif_clap`
                                ) AS `avif_clap`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_colr.key, avif_colr.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_colr) AS `avif_colr`
                                ) AS `avif_colr`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_decode_result.key, avif_decode_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_decode_result) AS `avif_decode_result`
                                ) AS `avif_decode_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_decoder.key, avif_decoder.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_decoder) AS `avif_decoder`
                                ) AS `avif_decoder`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_grid.key, avif_grid.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_grid) AS `avif_grid`
                                ) AS `avif_grid`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_ipro.key, avif_ipro.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_ipro) AS `avif_ipro`
                                ) AS `avif_ipro`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_ispe.key, avif_ispe.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_ispe) AS `avif_ispe`
                                ) AS `avif_ispe`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_lsel.key, avif_lsel.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_lsel) AS `avif_lsel`
                                ) AS `avif_lsel`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_pasp.key, avif_pasp.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_pasp) AS `avif_pasp`
                                ) AS `avif_pasp`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_pixi.key, avif_pixi.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_pixi) AS `avif_pixi`
                                ) AS `avif_pixi`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            avif_yuv_color_space.key, avif_yuv_color_space.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.avif_yuv_color_space) AS `avif_yuv_color_space`
                                ) AS `avif_yuv_color_space`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_proxy_info_type.key, networking_proxy_info_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_proxy_info_type) AS `networking_proxy_info_type`
                                ) AS `networking_proxy_info_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_editing_highlight_color.key, pdfjs_editing_highlight_color.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_editing_highlight_color) AS `pdfjs_editing_highlight_color`
                                ) AS `pdfjs_editing_highlight_color`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_editing_highlight_kind.key, pdfjs_editing_highlight_kind.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_editing_highlight_kind) AS `pdfjs_editing_highlight_kind`
                                ) AS `pdfjs_editing_highlight_kind`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_editing_highlight_method.key, pdfjs_editing_highlight_method.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_editing_highlight_method) AS `pdfjs_editing_highlight_method`
                                ) AS `pdfjs_editing_highlight_method`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_editing_highlight_number_of_colors.key, pdfjs_editing_highlight_number_of_colors.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_editing_highlight_number_of_colors) AS `pdfjs_editing_highlight_number_of_colors`
                                ) AS `pdfjs_editing_highlight_number_of_colors`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cert_verifier_crlite_status.key, cert_verifier_crlite_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cert_verifier_crlite_status) AS `cert_verifier_crlite_status`
                                ) AS `cert_verifier_crlite_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtcdtls_cipher.key, webrtcdtls_cipher.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtcdtls_cipher) AS `webrtcdtls_cipher`
                                ) AS `webrtcdtls_cipher`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtcdtls_client_handshake_result.key, webrtcdtls_client_handshake_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtcdtls_client_handshake_result) AS `webrtcdtls_client_handshake_result`
                                ) AS `webrtcdtls_client_handshake_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtcdtls_protocol_version.key, webrtcdtls_protocol_version.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtcdtls_protocol_version) AS `webrtcdtls_protocol_version`
                                ) AS `webrtcdtls_protocol_version`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtcdtls_server_handshake_result.key, webrtcdtls_server_handshake_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtcdtls_server_handshake_result) AS `webrtcdtls_server_handshake_result`
                                ) AS `webrtcdtls_server_handshake_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtcdtls_srtp_cipher.key, webrtcdtls_srtp_cipher.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtcdtls_srtp_cipher) AS `webrtcdtls_srtp_cipher`
                                ) AS `webrtcdtls_srtp_cipher`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_playback_not_supported_video_per_mime_type.key, media_playback_not_supported_video_per_mime_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.media_playback_not_supported_video_per_mime_type) AS `media_playback_not_supported_video_per_mime_type`
                                ) AS `media_playback_not_supported_video_per_mime_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            power_energy_per_process_type.key, power_energy_per_process_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.power_energy_per_process_type) AS `power_energy_per_process_type`
                                ) AS `power_energy_per_process_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            bounce_tracking_protection_purge_count.key, bounce_tracking_protection_purge_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.bounce_tracking_protection_purge_count) AS `bounce_tracking_protection_purge_count`
                                ) AS `bounce_tracking_protection_purge_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_tls_early_data_accepted.key, network_tls_early_data_accepted.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_tls_early_data_accepted) AS `network_tls_early_data_accepted`
                                ) AS `network_tls_early_data_accepted`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_tls_early_data_negotiated.key, network_tls_early_data_negotiated.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_tls_early_data_negotiated) AS `network_tls_early_data_negotiated`
                                ) AS `network_tls_early_data_negotiated`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_redirect_to_scheme_subresource.key, networking_http_redirect_to_scheme_subresource.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_redirect_to_scheme_subresource) AS `networking_http_redirect_to_scheme_subresource`
                                ) AS `networking_http_redirect_to_scheme_subresource`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_redirect_to_scheme_top_level.key, networking_http_redirect_to_scheme_top_level.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_redirect_to_scheme_top_level) AS `networking_http_redirect_to_scheme_top_level`
                                ) AS `networking_http_redirect_to_scheme_top_level`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            translations_request_count.key, translations_request_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.translations_request_count) AS `translations_request_count`
                                ) AS `translations_request_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cert_compression_failures.key, cert_compression_failures.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cert_compression_failures) AS `cert_compression_failures`
                                ) AS `cert_compression_failures`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cert_compression_used.key, cert_compression_used.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cert_compression_used) AS `cert_compression_used`
                                ) AS `cert_compression_used`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webauthn_create_authenticator_attachment.key, webauthn_create_authenticator_attachment.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webauthn_create_authenticator_attachment) AS `webauthn_create_authenticator_attachment`
                                ) AS `webauthn_create_authenticator_attachment`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webauthn_get_authenticator_attachment.key, webauthn_get_authenticator_attachment.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webauthn_get_authenticator_attachment) AS `webauthn_get_authenticator_attachment`
                                ) AS `webauthn_get_authenticator_attachment`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            crash_submission_collector_errors.key, crash_submission_collector_errors.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.crash_submission_collector_errors) AS `crash_submission_collector_errors`
                                ) AS `crash_submission_collector_errors`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            private_attribution_database.key, private_attribution_database.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.private_attribution_database) AS `private_attribution_database`
                                ) AS `private_attribution_database`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            private_attribution_measure_conversion.key, private_attribution_measure_conversion.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.private_attribution_measure_conversion) AS `private_attribution_measure_conversion`
                                ) AS `private_attribution_measure_conversion`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            private_attribution_save_impression.key, private_attribution_save_impression.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.private_attribution_save_impression) AS `private_attribution_save_impression`
                                ) AS `private_attribution_save_impression`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_byte_range_request.key, network_byte_range_request.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_byte_range_request) AS `network_byte_range_request`
                                ) AS `network_byte_range_request`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition.key, networking_http_channel_disposition.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition) AS `networking_http_channel_disposition`
                                ) AS `networking_http_channel_disposition`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition_disabled_no_reason.key, networking_http_channel_disposition_disabled_no_reason.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition_disabled_no_reason) AS `networking_http_channel_disposition_disabled_no_reason`
                                ) AS `networking_http_channel_disposition_disabled_no_reason`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition_disabled_upgrade.key, networking_http_channel_disposition_disabled_upgrade.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition_disabled_upgrade) AS `networking_http_channel_disposition_disabled_upgrade`
                                ) AS `networking_http_channel_disposition_disabled_upgrade`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition_disabled_wont.key, networking_http_channel_disposition_disabled_wont.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition_disabled_wont) AS `networking_http_channel_disposition_disabled_wont`
                                ) AS `networking_http_channel_disposition_disabled_wont`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition_enabled_no_reason.key, networking_http_channel_disposition_enabled_no_reason.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition_enabled_no_reason) AS `networking_http_channel_disposition_enabled_no_reason`
                                ) AS `networking_http_channel_disposition_enabled_no_reason`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition_enabled_upgrade.key, networking_http_channel_disposition_enabled_upgrade.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition_enabled_upgrade) AS `networking_http_channel_disposition_enabled_upgrade`
                                ) AS `networking_http_channel_disposition_enabled_upgrade`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_disposition_enabled_wont.key, networking_http_channel_disposition_enabled_wont.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_disposition_enabled_wont) AS `networking_http_channel_disposition_enabled_wont`
                                ) AS `networking_http_channel_disposition_enabled_wont`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_channel_onstart_status.key, networking_http_channel_onstart_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_channel_onstart_status) AS `networking_http_channel_onstart_status`
                                ) AS `networking_http_channel_onstart_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_to_https_upgrade_reason.key, networking_http_to_https_upgrade_reason.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_to_https_upgrade_reason) AS `networking_http_to_https_upgrade_reason`
                                ) AS `networking_http_to_https_upgrade_reason`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_response_status_code.key, networking_http_response_status_code.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_response_status_code) AS `networking_http_response_status_code`
                                ) AS `networking_http_response_status_code`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_eh_response_version.key, netwerk_eh_response_version.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_eh_response_version) AS `netwerk_eh_response_version`
                                ) AS `netwerk_eh_response_version`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            crash_submission_channel_status.key, crash_submission_channel_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.crash_submission_channel_status) AS `crash_submission_channel_status`
                                ) AS `crash_submission_channel_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            geolocation_fallback.key, geolocation_fallback.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.geolocation_fallback) AS `geolocation_fallback`
                                ) AS `geolocation_fallback`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            geolocation_request_result.key, geolocation_request_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.geolocation_request_result) AS `geolocation_request_result`
                                ) AS `geolocation_request_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            serp_ads_blocked_count.key, serp_ads_blocked_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.serp_ads_blocked_count) AS `serp_ads_blocked_count`
                                ) AS `serp_ads_blocked_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cert_verifier_cert_revocation_mechanisms.key, cert_verifier_cert_revocation_mechanisms.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cert_verifier_cert_revocation_mechanisms) AS `cert_verifier_cert_revocation_mechanisms`
                                ) AS `cert_verifier_cert_revocation_mechanisms`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cert_verifier_crlite_vs_ocsp_result.key, cert_verifier_crlite_vs_ocsp_result.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.cert_verifier_crlite_vs_ocsp_result) AS `cert_verifier_crlite_vs_ocsp_result`
                                ) AS `cert_verifier_crlite_vs_ocsp_result`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_image_added.key, pdfjs_image_added.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.pdfjs_image_added) AS `pdfjs_image_added`
                                ) AS `pdfjs_image_added`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_fetch_keepalive_discard_count.key, networking_fetch_keepalive_discard_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_fetch_keepalive_discard_count) AS `networking_fetch_keepalive_discard_count`
                                ) AS `networking_fetch_keepalive_discard_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_fetch_keepalive_request_count.key, networking_fetch_keepalive_request_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_fetch_keepalive_request_count) AS `networking_fetch_keepalive_request_count`
                                ) AS `networking_fetch_keepalive_request_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_addon_status.key, network_system_channel_addon_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_addon_status) AS `network_system_channel_addon_status`
                                ) AS `network_system_channel_addon_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_other_status.key, network_system_channel_other_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_other_status) AS `network_system_channel_other_status`
                                ) AS `network_system_channel_other_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_remote_settings_status.key, network_system_channel_remote_settings_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_remote_settings_status) AS `network_system_channel_remote_settings_status`
                                ) AS `network_system_channel_remote_settings_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_success_or_failure.key, network_system_channel_success_or_failure.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_success_or_failure) AS `network_system_channel_success_or_failure`
                                ) AS `network_system_channel_success_or_failure`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_telemetry_status.key, network_system_channel_telemetry_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_telemetry_status) AS `network_system_channel_telemetry_status`
                                ) AS `network_system_channel_telemetry_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_update_status.key, network_system_channel_update_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_update_status) AS `network_system_channel_update_status`
                                ) AS `network_system_channel_update_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_system_channel_addonversion_status.key, network_system_channel_addonversion_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_system_channel_addonversion_status) AS `network_system_channel_addonversion_status`
                                ) AS `network_system_channel_addonversion_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_trr_request_count_per_conn.key, networking_trr_request_count_per_conn.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_trr_request_count_per_conn) AS `networking_trr_request_count_per_conn`
                                ) AS `networking_trr_request_count_per_conn`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_3_ecn_path_capability.key, networking_http_3_ecn_path_capability.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_3_ecn_path_capability) AS `networking_http_3_ecn_path_capability`
                                ) AS `networking_http_3_ecn_path_capability`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_http3_0rtt_state.key, netwerk_http3_0rtt_state.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_http3_0rtt_state) AS `netwerk_http3_0rtt_state`
                                ) AS `netwerk_http3_0rtt_state`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_http3_ech_outcome_grease.key, netwerk_http3_ech_outcome_grease.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_http3_ech_outcome_grease) AS `netwerk_http3_ech_outcome_grease`
                                ) AS `netwerk_http3_ech_outcome_grease`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_http3_ech_outcome_none.key, netwerk_http3_ech_outcome_none.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_http3_ech_outcome_none) AS `netwerk_http3_ech_outcome_none`
                                ) AS `netwerk_http3_ech_outcome_none`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_http3_ech_outcome_real.key, netwerk_http3_ech_outcome_real.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.netwerk_http3_ech_outcome_real) AS `netwerk_http3_ech_outcome_real`
                                ) AS `netwerk_http3_ech_outcome_real`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            web_notification_permission_origin.key, web_notification_permission_origin.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.web_notification_permission_origin) AS `web_notification_permission_origin`
                                ) AS `web_notification_permission_origin`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            web_notification_request_permission_origin.key, web_notification_request_permission_origin.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.web_notification_request_permission_origin) AS `web_notification_request_permission_origin`
                                ) AS `web_notification_request_permission_origin`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            web_notification_show_origin.key, web_notification_show_origin.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.web_notification_show_origin) AS `web_notification_show_origin`
                                ) AS `web_notification_show_origin`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_ip_addr_any_count.key, networking_http_ip_addr_any_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_ip_addr_any_count) AS `networking_http_ip_addr_any_count`
                                ) AS `networking_http_ip_addr_any_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            library_link.key, library_link.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.library_link) AS `library_link`
                                ) AS `library_link`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            library_opened.key, library_opened.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.library_opened) AS `library_opened`
                                ) AS `library_opened`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            library_search.key, library_search.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.library_search) AS `library_search`
                                ) AS `library_search`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            sidebar_link.key, sidebar_link.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.sidebar_link) AS `sidebar_link`
                                ) AS `sidebar_link`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            sidebar_search.key, sidebar_search.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.sidebar_search) AS `sidebar_search`
                                ) AS `sidebar_search`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_decode_error_per_mime_type.key, media_decode_error_per_mime_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.media_decode_error_per_mime_type) AS `media_decode_error_per_mime_type`
                                ) AS `media_decode_error_per_mime_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_data_transferred_v3_kb.key, networking_data_transferred_v3_kb.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_data_transferred_v3_kb) AS `networking_data_transferred_v3_kb`
                                ) AS `networking_data_transferred_v3_kb`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_trr_connection_cycle_count.key, networking_trr_connection_cycle_count.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_trr_connection_cycle_count) AS `networking_trr_connection_cycle_count`
                                ) AS `networking_trr_connection_cycle_count`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtc_video_recv_codec_used.key, webrtc_video_recv_codec_used.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtc_video_recv_codec_used) AS `webrtc_video_recv_codec_used`
                                ) AS `webrtc_video_recv_codec_used`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            webrtc_video_send_codec_used.key, webrtc_video_send_codec_used.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.webrtc_video_send_codec_used) AS `webrtc_video_send_codec_used`
                                ) AS `webrtc_video_send_codec_used`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            migration_discovered_migrators.key, migration_discovered_migrators.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.migration_discovered_migrators) AS `migration_discovered_migrators`
                                ) AS `migration_discovered_migrators`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            os_environment_invoked_to_handle.key, os_environment_invoked_to_handle.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.os_environment_invoked_to_handle) AS `os_environment_invoked_to_handle`
                                ) AS `os_environment_invoked_to_handle`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            os_environment_launched_to_handle.key, os_environment_launched_to_handle.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.os_environment_launched_to_handle) AS `os_environment_launched_to_handle`
                                ) AS `os_environment_launched_to_handle`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            security_client_auth_cert_usage.key, security_client_auth_cert_usage.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.security_client_auth_cert_usage) AS `security_client_auth_cert_usage`
                                ) AS `security_client_auth_cert_usage`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            printing_error.key, printing_error.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.printing_error) AS `printing_error`
                                ) AS `printing_error`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            printing_settings_changed.key, printing_settings_changed.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.printing_settings_changed) AS `printing_settings_changed`
                                ) AS `printing_settings_changed`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            printing_target_type.key, printing_target_type.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.printing_target_type) AS `printing_target_type`
                                ) AS `printing_target_type`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_about_home.key, browser_engagement_navigation_about_home.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_about_home) AS `browser_engagement_navigation_about_home`
                                ) AS `browser_engagement_navigation_about_home`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_about_newtab.key, browser_engagement_navigation_about_newtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_about_newtab) AS `browser_engagement_navigation_about_newtab`
                                ) AS `browser_engagement_navigation_about_newtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_contextmenu.key, browser_engagement_navigation_contextmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_contextmenu) AS `browser_engagement_navigation_contextmenu`
                                ) AS `browser_engagement_navigation_contextmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_searchbar.key, browser_engagement_navigation_searchbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_searchbar) AS `browser_engagement_navigation_searchbar`
                                ) AS `browser_engagement_navigation_searchbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_urlbar.key, browser_engagement_navigation_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_urlbar) AS `browser_engagement_navigation_urlbar`
                                ) AS `browser_engagement_navigation_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_urlbar_handoff.key, browser_engagement_navigation_urlbar_handoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_urlbar_handoff) AS `browser_engagement_navigation_urlbar_handoff`
                                ) AS `browser_engagement_navigation_urlbar_handoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_urlbar_persisted.key, browser_engagement_navigation_urlbar_persisted.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_urlbar_persisted) AS `browser_engagement_navigation_urlbar_persisted`
                                ) AS `browser_engagement_navigation_urlbar_persisted`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_urlbar_searchmode.key, browser_engagement_navigation_urlbar_searchmode.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_urlbar_searchmode) AS `browser_engagement_navigation_urlbar_searchmode`
                                ) AS `browser_engagement_navigation_urlbar_searchmode`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_navigation_webextension.key, browser_engagement_navigation_webextension.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_navigation_webextension) AS `browser_engagement_navigation_webextension`
                                ) AS `browser_engagement_navigation_webextension`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_about_home.key, browser_search_adclicks_about_home.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_about_home) AS `browser_search_adclicks_about_home`
                                ) AS `browser_search_adclicks_about_home`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_about_newtab.key, browser_search_adclicks_about_newtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_about_newtab) AS `browser_search_adclicks_about_newtab`
                                ) AS `browser_search_adclicks_about_newtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_contextmenu.key, browser_search_adclicks_contextmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_contextmenu) AS `browser_search_adclicks_contextmenu`
                                ) AS `browser_search_adclicks_contextmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_reload.key, browser_search_adclicks_reload.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_reload) AS `browser_search_adclicks_reload`
                                ) AS `browser_search_adclicks_reload`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_searchbar.key, browser_search_adclicks_searchbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_searchbar) AS `browser_search_adclicks_searchbar`
                                ) AS `browser_search_adclicks_searchbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_system.key, browser_search_adclicks_system.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_system) AS `browser_search_adclicks_system`
                                ) AS `browser_search_adclicks_system`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_tabhistory.key, browser_search_adclicks_tabhistory.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_tabhistory) AS `browser_search_adclicks_tabhistory`
                                ) AS `browser_search_adclicks_tabhistory`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_unknown.key, browser_search_adclicks_unknown.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_unknown) AS `browser_search_adclicks_unknown`
                                ) AS `browser_search_adclicks_unknown`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_urlbar.key, browser_search_adclicks_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_urlbar) AS `browser_search_adclicks_urlbar`
                                ) AS `browser_search_adclicks_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_urlbar_handoff.key, browser_search_adclicks_urlbar_handoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_urlbar_handoff) AS `browser_search_adclicks_urlbar_handoff`
                                ) AS `browser_search_adclicks_urlbar_handoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_urlbar_persisted.key, browser_search_adclicks_urlbar_persisted.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_urlbar_persisted) AS `browser_search_adclicks_urlbar_persisted`
                                ) AS `browser_search_adclicks_urlbar_persisted`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_urlbar_searchmode.key, browser_search_adclicks_urlbar_searchmode.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_urlbar_searchmode) AS `browser_search_adclicks_urlbar_searchmode`
                                ) AS `browser_search_adclicks_urlbar_searchmode`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_adclicks_webextension.key, browser_search_adclicks_webextension.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_adclicks_webextension) AS `browser_search_adclicks_webextension`
                                ) AS `browser_search_adclicks_webextension`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_about_home.key, browser_search_content_about_home.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_about_home) AS `browser_search_content_about_home`
                                ) AS `browser_search_content_about_home`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_about_newtab.key, browser_search_content_about_newtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_about_newtab) AS `browser_search_content_about_newtab`
                                ) AS `browser_search_content_about_newtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_contextmenu.key, browser_search_content_contextmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_contextmenu) AS `browser_search_content_contextmenu`
                                ) AS `browser_search_content_contextmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_reload.key, browser_search_content_reload.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_reload) AS `browser_search_content_reload`
                                ) AS `browser_search_content_reload`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_searchbar.key, browser_search_content_searchbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_searchbar) AS `browser_search_content_searchbar`
                                ) AS `browser_search_content_searchbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_system.key, browser_search_content_system.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_system) AS `browser_search_content_system`
                                ) AS `browser_search_content_system`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_tabhistory.key, browser_search_content_tabhistory.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_tabhistory) AS `browser_search_content_tabhistory`
                                ) AS `browser_search_content_tabhistory`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_unknown.key, browser_search_content_unknown.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_unknown) AS `browser_search_content_unknown`
                                ) AS `browser_search_content_unknown`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_urlbar.key, browser_search_content_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_urlbar) AS `browser_search_content_urlbar`
                                ) AS `browser_search_content_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_urlbar_handoff.key, browser_search_content_urlbar_handoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_urlbar_handoff) AS `browser_search_content_urlbar_handoff`
                                ) AS `browser_search_content_urlbar_handoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_urlbar_persisted.key, browser_search_content_urlbar_persisted.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_urlbar_persisted) AS `browser_search_content_urlbar_persisted`
                                ) AS `browser_search_content_urlbar_persisted`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_urlbar_searchmode.key, browser_search_content_urlbar_searchmode.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_urlbar_searchmode) AS `browser_search_content_urlbar_searchmode`
                                ) AS `browser_search_content_urlbar_searchmode`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_content_webextension.key, browser_search_content_webextension.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_content_webextension) AS `browser_search_content_webextension`
                                ) AS `browser_search_content_webextension`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_about_home.key, browser_search_withads_about_home.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_about_home) AS `browser_search_withads_about_home`
                                ) AS `browser_search_withads_about_home`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_about_newtab.key, browser_search_withads_about_newtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_about_newtab) AS `browser_search_withads_about_newtab`
                                ) AS `browser_search_withads_about_newtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_contextmenu.key, browser_search_withads_contextmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_contextmenu) AS `browser_search_withads_contextmenu`
                                ) AS `browser_search_withads_contextmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_reload.key, browser_search_withads_reload.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_reload) AS `browser_search_withads_reload`
                                ) AS `browser_search_withads_reload`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_searchbar.key, browser_search_withads_searchbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_searchbar) AS `browser_search_withads_searchbar`
                                ) AS `browser_search_withads_searchbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_system.key, browser_search_withads_system.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_system) AS `browser_search_withads_system`
                                ) AS `browser_search_withads_system`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_tabhistory.key, browser_search_withads_tabhistory.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_tabhistory) AS `browser_search_withads_tabhistory`
                                ) AS `browser_search_withads_tabhistory`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_unknown.key, browser_search_withads_unknown.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_unknown) AS `browser_search_withads_unknown`
                                ) AS `browser_search_withads_unknown`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_urlbar.key, browser_search_withads_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_urlbar) AS `browser_search_withads_urlbar`
                                ) AS `browser_search_withads_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_urlbar_handoff.key, browser_search_withads_urlbar_handoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_urlbar_handoff) AS `browser_search_withads_urlbar_handoff`
                                ) AS `browser_search_withads_urlbar_handoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_urlbar_persisted.key, browser_search_withads_urlbar_persisted.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_urlbar_persisted) AS `browser_search_withads_urlbar_persisted`
                                ) AS `browser_search_withads_urlbar_persisted`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_urlbar_searchmode.key, browser_search_withads_urlbar_searchmode.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_urlbar_searchmode) AS `browser_search_withads_urlbar_searchmode`
                                ) AS `browser_search_withads_urlbar_searchmode`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_search_withads_webextension.key, browser_search_withads_webextension.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_search_withads_webextension) AS `browser_search_withads_webextension`
                                ) AS `browser_search_withads_webextension`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_app_menu.key, browser_ui_interaction_app_menu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_app_menu) AS `browser_ui_interaction_app_menu`
                                ) AS `browser_ui_interaction_app_menu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_bookmarks_bar.key, browser_ui_interaction_bookmarks_bar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_bookmarks_bar) AS `browser_ui_interaction_bookmarks_bar`
                                ) AS `browser_ui_interaction_bookmarks_bar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_content_context.key, browser_ui_interaction_content_context.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_content_context) AS `browser_ui_interaction_content_context`
                                ) AS `browser_ui_interaction_content_context`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_menu_bar.key, browser_ui_interaction_menu_bar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_menu_bar) AS `browser_ui_interaction_menu_bar`
                                ) AS `browser_ui_interaction_menu_bar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_nav_bar.key, browser_ui_interaction_nav_bar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_nav_bar) AS `browser_ui_interaction_nav_bar`
                                ) AS `browser_ui_interaction_nav_bar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_overflow_menu.key, browser_ui_interaction_overflow_menu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_overflow_menu) AS `browser_ui_interaction_overflow_menu`
                                ) AS `browser_ui_interaction_overflow_menu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_pageaction_panel.key, browser_ui_interaction_pageaction_panel.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_pageaction_panel) AS `browser_ui_interaction_pageaction_panel`
                                ) AS `browser_ui_interaction_pageaction_panel`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_pageaction_urlbar.key, browser_ui_interaction_pageaction_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_pageaction_urlbar) AS `browser_ui_interaction_pageaction_urlbar`
                                ) AS `browser_ui_interaction_pageaction_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_pinned_overflow_menu.key, browser_ui_interaction_pinned_overflow_menu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_pinned_overflow_menu) AS `browser_ui_interaction_pinned_overflow_menu`
                                ) AS `browser_ui_interaction_pinned_overflow_menu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_containers.key, browser_ui_interaction_preferences_pane_containers.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_containers) AS `browser_ui_interaction_preferences_pane_containers`
                                ) AS `browser_ui_interaction_preferences_pane_containers`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_experimental.key, browser_ui_interaction_preferences_pane_experimental.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_experimental) AS `browser_ui_interaction_preferences_pane_experimental`
                                ) AS `browser_ui_interaction_preferences_pane_experimental`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_general.key, browser_ui_interaction_preferences_pane_general.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_general) AS `browser_ui_interaction_preferences_pane_general`
                                ) AS `browser_ui_interaction_preferences_pane_general`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_home.key, browser_ui_interaction_preferences_pane_home.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_home) AS `browser_ui_interaction_preferences_pane_home`
                                ) AS `browser_ui_interaction_preferences_pane_home`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_more_from_mozilla.key, browser_ui_interaction_preferences_pane_more_from_mozilla.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_more_from_mozilla) AS `browser_ui_interaction_preferences_pane_more_from_mozilla`
                                ) AS `browser_ui_interaction_preferences_pane_more_from_mozilla`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_privacy.key, browser_ui_interaction_preferences_pane_privacy.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_privacy) AS `browser_ui_interaction_preferences_pane_privacy`
                                ) AS `browser_ui_interaction_preferences_pane_privacy`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_search.key, browser_ui_interaction_preferences_pane_search.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_search) AS `browser_ui_interaction_preferences_pane_search`
                                ) AS `browser_ui_interaction_preferences_pane_search`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_search_results.key, browser_ui_interaction_preferences_pane_search_results.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_search_results) AS `browser_ui_interaction_preferences_pane_search_results`
                                ) AS `browser_ui_interaction_preferences_pane_search_results`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_sync.key, browser_ui_interaction_preferences_pane_sync.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_sync) AS `browser_ui_interaction_preferences_pane_sync`
                                ) AS `browser_ui_interaction_preferences_pane_sync`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_preferences_pane_unknown.key, browser_ui_interaction_preferences_pane_unknown.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_preferences_pane_unknown) AS `browser_ui_interaction_preferences_pane_unknown`
                                ) AS `browser_ui_interaction_preferences_pane_unknown`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_tabs_bar.key, browser_ui_interaction_tabs_bar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_tabs_bar) AS `browser_ui_interaction_tabs_bar`
                                ) AS `browser_ui_interaction_tabs_bar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_tabs_context.key, browser_ui_interaction_tabs_context.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_tabs_context) AS `browser_ui_interaction_tabs_context`
                                ) AS `browser_ui_interaction_tabs_context`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_tabs_context_entrypoint.key, browser_ui_interaction_tabs_context_entrypoint.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_tabs_context_entrypoint) AS `browser_ui_interaction_tabs_context_entrypoint`
                                ) AS `browser_ui_interaction_tabs_context_entrypoint`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_unified_extensions_area.key, browser_ui_interaction_unified_extensions_area.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_unified_extensions_area) AS `browser_ui_interaction_unified_extensions_area`
                                ) AS `browser_ui_interaction_unified_extensions_area`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_vertical_tabs_container.key, browser_ui_interaction_vertical_tabs_container.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_vertical_tabs_container) AS `browser_ui_interaction_vertical_tabs_container`
                                ) AS `browser_ui_interaction_vertical_tabs_container`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            dom_parentprocess_process_launch_errors.key, dom_parentprocess_process_launch_errors.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.dom_parentprocess_process_launch_errors) AS `dom_parentprocess_process_launch_errors`
                                ) AS `dom_parentprocess_process_launch_errors`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            suggest_relevance_outcome.key, suggest_relevance_outcome.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.suggest_relevance_outcome) AS `suggest_relevance_outcome`
                                ) AS `suggest_relevance_outcome`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            suggest_relevance_status.key, suggest_relevance_status.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.suggest_relevance_status) AS `suggest_relevance_status`
                                ) AS `suggest_relevance_status`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_bookmarkmenu.key, urlbar_searchmode_bookmarkmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_bookmarkmenu) AS `urlbar_searchmode_bookmarkmenu`
                                ) AS `urlbar_searchmode_bookmarkmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_handoff.key, urlbar_searchmode_handoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_handoff) AS `urlbar_searchmode_handoff`
                                ) AS `urlbar_searchmode_handoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_historymenu.key, urlbar_searchmode_historymenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_historymenu) AS `urlbar_searchmode_historymenu`
                                ) AS `urlbar_searchmode_historymenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_keywordoffer.key, urlbar_searchmode_keywordoffer.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_keywordoffer) AS `urlbar_searchmode_keywordoffer`
                                ) AS `urlbar_searchmode_keywordoffer`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_oneoff.key, urlbar_searchmode_oneoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_oneoff) AS `urlbar_searchmode_oneoff`
                                ) AS `urlbar_searchmode_oneoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_other.key, urlbar_searchmode_other.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_other) AS `urlbar_searchmode_other`
                                ) AS `urlbar_searchmode_other`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_searchbutton.key, urlbar_searchmode_searchbutton.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_searchbutton) AS `urlbar_searchmode_searchbutton`
                                ) AS `urlbar_searchmode_searchbutton`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_shortcut.key, urlbar_searchmode_shortcut.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_shortcut) AS `urlbar_searchmode_shortcut`
                                ) AS `urlbar_searchmode_shortcut`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_tabmenu.key, urlbar_searchmode_tabmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_tabmenu) AS `urlbar_searchmode_tabmenu`
                                ) AS `urlbar_searchmode_tabmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_tabtosearch.key, urlbar_searchmode_tabtosearch.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_tabtosearch) AS `urlbar_searchmode_tabtosearch`
                                ) AS `urlbar_searchmode_tabtosearch`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_tabtosearch_onboard.key, urlbar_searchmode_tabtosearch_onboard.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_tabtosearch_onboard) AS `urlbar_searchmode_tabtosearch_onboard`
                                ) AS `urlbar_searchmode_tabtosearch_onboard`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_topsites_newtab.key, urlbar_searchmode_topsites_newtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_topsites_newtab) AS `urlbar_searchmode_topsites_newtab`
                                ) AS `urlbar_searchmode_topsites_newtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_topsites_urlbar.key, urlbar_searchmode_topsites_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_topsites_urlbar) AS `urlbar_searchmode_topsites_urlbar`
                                ) AS `urlbar_searchmode_topsites_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_touchbar.key, urlbar_searchmode_touchbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_touchbar) AS `urlbar_searchmode_touchbar`
                                ) AS `urlbar_searchmode_touchbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_searchmode_typed.key, urlbar_searchmode_typed.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_searchmode_typed) AS `urlbar_searchmode_typed`
                                ) AS `urlbar_searchmode_typed`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_customized_widgets.key, browser_ui_customized_widgets.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_customized_widgets) AS `browser_ui_customized_widgets`
                                ) AS `browser_ui_customized_widgets`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_all_tabs_panel_entrypoint.key, browser_ui_interaction_all_tabs_panel_entrypoint.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_all_tabs_panel_entrypoint) AS `browser_ui_interaction_all_tabs_panel_entrypoint`
                                ) AS `browser_ui_interaction_all_tabs_panel_entrypoint`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_interaction_keyboard.key, browser_ui_interaction_keyboard.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_ui_interaction_keyboard) AS `browser_ui_interaction_keyboard`
                                ) AS `browser_ui_interaction_keyboard`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_3_connection_close_reason.key, networking_http_3_connection_close_reason.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.networking_http_3_connection_close_reason) AS `networking_http_3_connection_close_reason`
                                ) AS `networking_http_3_connection_close_reason`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            web_push_content_encoding.key, web_push_content_encoding.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.web_push_content_encoding) AS `web_push_content_encoding`
                                ) AS `web_push_content_encoding`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            web_push_error_code.key, web_push_error_code.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.web_push_error_code) AS `web_push_error_code`
                                ) AS `web_push_error_code`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_engagement_sessionrestore_interstitial.key, browser_engagement_sessionrestore_interstitial.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.browser_engagement_sessionrestore_interstitial) AS `browser_engagement_sessionrestore_interstitial`
                                ) AS `browser_engagement_sessionrestore_interstitial`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_autofill_about.key, urlbar_picked_autofill_about.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_autofill_about) AS `urlbar_picked_autofill_about`
                                ) AS `urlbar_picked_autofill_about`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_autofill_adaptive.key, urlbar_picked_autofill_adaptive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_autofill_adaptive) AS `urlbar_picked_autofill_adaptive`
                                ) AS `urlbar_picked_autofill_adaptive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_autofill_origin.key, urlbar_picked_autofill_origin.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_autofill_origin) AS `urlbar_picked_autofill_origin`
                                ) AS `urlbar_picked_autofill_origin`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_autofill_other.key, urlbar_picked_autofill_other.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_autofill_other) AS `urlbar_picked_autofill_other`
                                ) AS `urlbar_picked_autofill_other`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_autofill_url.key, urlbar_picked_autofill_url.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_autofill_url) AS `urlbar_picked_autofill_url`
                                ) AS `urlbar_picked_autofill_url`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_bookmark.key, urlbar_picked_bookmark.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_bookmark) AS `urlbar_picked_bookmark`
                                ) AS `urlbar_picked_bookmark`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_bookmark_adaptive.key, urlbar_picked_bookmark_adaptive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_bookmark_adaptive) AS `urlbar_picked_bookmark_adaptive`
                                ) AS `urlbar_picked_bookmark_adaptive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_clipboard.key, urlbar_picked_clipboard.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_clipboard) AS `urlbar_picked_clipboard`
                                ) AS `urlbar_picked_clipboard`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_dynamic.key, urlbar_picked_dynamic.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_dynamic) AS `urlbar_picked_dynamic`
                                ) AS `urlbar_picked_dynamic`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_dynamic_wikipedia.key, urlbar_picked_dynamic_wikipedia.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_dynamic_wikipedia) AS `urlbar_picked_dynamic_wikipedia`
                                ) AS `urlbar_picked_dynamic_wikipedia`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_extension.key, urlbar_picked_extension.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_extension) AS `urlbar_picked_extension`
                                ) AS `urlbar_picked_extension`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_formhistory.key, urlbar_picked_formhistory.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_formhistory) AS `urlbar_picked_formhistory`
                                ) AS `urlbar_picked_formhistory`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_history.key, urlbar_picked_history.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_history) AS `urlbar_picked_history`
                                ) AS `urlbar_picked_history`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_history_adaptive.key, urlbar_picked_history_adaptive.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_history_adaptive) AS `urlbar_picked_history_adaptive`
                                ) AS `urlbar_picked_history_adaptive`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_keyword.key, urlbar_picked_keyword.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_keyword) AS `urlbar_picked_keyword`
                                ) AS `urlbar_picked_keyword`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_navigational.key, urlbar_picked_navigational.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_navigational) AS `urlbar_picked_navigational`
                                ) AS `urlbar_picked_navigational`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_quickaction.key, urlbar_picked_quickaction.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_quickaction) AS `urlbar_picked_quickaction`
                                ) AS `urlbar_picked_quickaction`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_quicksuggest.key, urlbar_picked_quicksuggest.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_quicksuggest) AS `urlbar_picked_quicksuggest`
                                ) AS `urlbar_picked_quicksuggest`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_recent_search.key, urlbar_picked_recent_search.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_recent_search) AS `urlbar_picked_recent_search`
                                ) AS `urlbar_picked_recent_search`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_remotetab.key, urlbar_picked_remotetab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_remotetab) AS `urlbar_picked_remotetab`
                                ) AS `urlbar_picked_remotetab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_restrict_keyword_actions.key, urlbar_picked_restrict_keyword_actions.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_restrict_keyword_actions) AS `urlbar_picked_restrict_keyword_actions`
                                ) AS `urlbar_picked_restrict_keyword_actions`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_restrict_keyword_bookmarks.key, urlbar_picked_restrict_keyword_bookmarks.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_restrict_keyword_bookmarks) AS `urlbar_picked_restrict_keyword_bookmarks`
                                ) AS `urlbar_picked_restrict_keyword_bookmarks`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_restrict_keyword_history.key, urlbar_picked_restrict_keyword_history.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_restrict_keyword_history) AS `urlbar_picked_restrict_keyword_history`
                                ) AS `urlbar_picked_restrict_keyword_history`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_restrict_keyword_tabs.key, urlbar_picked_restrict_keyword_tabs.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_restrict_keyword_tabs) AS `urlbar_picked_restrict_keyword_tabs`
                                ) AS `urlbar_picked_restrict_keyword_tabs`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchengine.key, urlbar_picked_searchengine.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchengine) AS `urlbar_picked_searchengine`
                                ) AS `urlbar_picked_searchengine`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_bookmarkmenu.key, urlbar_picked_searchmode_bookmarkmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_bookmarkmenu) AS `urlbar_picked_searchmode_bookmarkmenu`
                                ) AS `urlbar_picked_searchmode_bookmarkmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_handoff.key, urlbar_picked_searchmode_handoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_handoff) AS `urlbar_picked_searchmode_handoff`
                                ) AS `urlbar_picked_searchmode_handoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_historymenu.key, urlbar_picked_searchmode_historymenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_historymenu) AS `urlbar_picked_searchmode_historymenu`
                                ) AS `urlbar_picked_searchmode_historymenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_keywordoffer.key, urlbar_picked_searchmode_keywordoffer.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_keywordoffer) AS `urlbar_picked_searchmode_keywordoffer`
                                ) AS `urlbar_picked_searchmode_keywordoffer`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_oneoff.key, urlbar_picked_searchmode_oneoff.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_oneoff) AS `urlbar_picked_searchmode_oneoff`
                                ) AS `urlbar_picked_searchmode_oneoff`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_other.key, urlbar_picked_searchmode_other.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_other) AS `urlbar_picked_searchmode_other`
                                ) AS `urlbar_picked_searchmode_other`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_searchbutton.key, urlbar_picked_searchmode_searchbutton.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_searchbutton) AS `urlbar_picked_searchmode_searchbutton`
                                ) AS `urlbar_picked_searchmode_searchbutton`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_shortcut.key, urlbar_picked_searchmode_shortcut.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_shortcut) AS `urlbar_picked_searchmode_shortcut`
                                ) AS `urlbar_picked_searchmode_shortcut`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_tabmenu.key, urlbar_picked_searchmode_tabmenu.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_tabmenu) AS `urlbar_picked_searchmode_tabmenu`
                                ) AS `urlbar_picked_searchmode_tabmenu`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_tabtosearch.key, urlbar_picked_searchmode_tabtosearch.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_tabtosearch) AS `urlbar_picked_searchmode_tabtosearch`
                                ) AS `urlbar_picked_searchmode_tabtosearch`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_tabtosearch_onboard.key, urlbar_picked_searchmode_tabtosearch_onboard.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_tabtosearch_onboard) AS `urlbar_picked_searchmode_tabtosearch_onboard`
                                ) AS `urlbar_picked_searchmode_tabtosearch_onboard`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_topsites_newtab.key, urlbar_picked_searchmode_topsites_newtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_topsites_newtab) AS `urlbar_picked_searchmode_topsites_newtab`
                                ) AS `urlbar_picked_searchmode_topsites_newtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_topsites_urlbar.key, urlbar_picked_searchmode_topsites_urlbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_topsites_urlbar) AS `urlbar_picked_searchmode_topsites_urlbar`
                                ) AS `urlbar_picked_searchmode_topsites_urlbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_touchbar.key, urlbar_picked_searchmode_touchbar.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_touchbar) AS `urlbar_picked_searchmode_touchbar`
                                ) AS `urlbar_picked_searchmode_touchbar`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchmode_typed.key, urlbar_picked_searchmode_typed.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchmode_typed) AS `urlbar_picked_searchmode_typed`
                                ) AS `urlbar_picked_searchmode_typed`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchsuggestion.key, urlbar_picked_searchsuggestion.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchsuggestion) AS `urlbar_picked_searchsuggestion`
                                ) AS `urlbar_picked_searchsuggestion`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_searchsuggestion_rich.key, urlbar_picked_searchsuggestion_rich.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_searchsuggestion_rich) AS `urlbar_picked_searchsuggestion_rich`
                                ) AS `urlbar_picked_searchsuggestion_rich`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_switchtab.key, urlbar_picked_switchtab.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_switchtab) AS `urlbar_picked_switchtab`
                                ) AS `urlbar_picked_switchtab`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_tabtosearch.key, urlbar_picked_tabtosearch.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_tabtosearch) AS `urlbar_picked_tabtosearch`
                                ) AS `urlbar_picked_tabtosearch`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_tip.key, urlbar_picked_tip.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_tip) AS `urlbar_picked_tip`
                                ) AS `urlbar_picked_tip`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_topsite.key, urlbar_picked_topsite.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_topsite) AS `urlbar_picked_topsite`
                                ) AS `urlbar_picked_topsite`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_trending.key, urlbar_picked_trending.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_trending) AS `urlbar_picked_trending`
                                ) AS `urlbar_picked_trending`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_trending_rich.key, urlbar_picked_trending_rich.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_trending_rich) AS `urlbar_picked_trending_rich`
                                ) AS `urlbar_picked_trending_rich`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_unknown.key, urlbar_picked_unknown.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_unknown) AS `urlbar_picked_unknown`
                                ) AS `urlbar_picked_unknown`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_visiturl.key, urlbar_picked_visiturl.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_visiturl) AS `urlbar_picked_visiturl`
                                ) AS `urlbar_picked_visiturl`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_picked_weather.key, urlbar_picked_weather.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_picked_weather) AS `urlbar_picked_weather`
                                ) AS `urlbar_picked_weather`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_tabtosearch_impressions.key, urlbar_tabtosearch_impressions.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_tabtosearch_impressions) AS `urlbar_tabtosearch_impressions`
                                ) AS `urlbar_tabtosearch_impressions`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_tabtosearch_impressions_onboarding.key, urlbar_tabtosearch_impressions_onboarding.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_tabtosearch_impressions_onboarding) AS `urlbar_tabtosearch_impressions_onboarding`
                                ) AS `urlbar_tabtosearch_impressions_onboarding`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            urlbar_tips.key, urlbar_tips.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.urlbar_tips) AS `urlbar_tips`
                                ) AS `urlbar_tips`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_cache_hit_miss_stat_per_cache_size.key, network_cache_hit_miss_stat_per_cache_size.value
                                        )
                                    FROM UNNEST(metrics.labeled_counter.network_cache_hit_miss_stat_per_cache_size) AS `network_cache_hit_miss_stat_per_cache_size`
                                ) AS `network_cache_hit_miss_stat_per_cache_size`
                            
                                ) AS `labeled_counter`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metrics.memory_distribution.glean_upload_discarded_exceeding_pings_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.glean_upload_discarded_exceeding_pings_size.values) AS `values`
                                ) AS `values`
                            , metrics.memory_distribution.glean_upload_discarded_exceeding_pings_size.count
                                ) AS `glean_upload_discarded_exceeding_pings_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.glean_upload_pending_pings_directory_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.glean_upload_pending_pings_directory_size.values) AS `values`
                                ) AS `values`
                            , metrics.memory_distribution.glean_upload_pending_pings_directory_size.count
                                ) AS `glean_upload_pending_pings_directory_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.glean_database_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.glean_database_size.values) AS `values`
                                ) AS `values`
                            , metrics.memory_distribution.glean_database_size.count
                                ) AS `glean_database_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.fog_ipc_buffer_sizes.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.fog_ipc_buffer_sizes.values) AS `values`
                                ) AS `values`
                            , metrics.memory_distribution.fog_ipc_buffer_sizes.count
                                ) AS `fog_ipc_buffer_sizes`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.extensions_apis_dnr_startup_cache_read_size.count, metrics.memory_distribution.extensions_apis_dnr_startup_cache_read_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.extensions_apis_dnr_startup_cache_read_size.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_apis_dnr_startup_cache_read_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.extensions_apis_dnr_startup_cache_write_size.count, metrics.memory_distribution.extensions_apis_dnr_startup_cache_write_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.extensions_apis_dnr_startup_cache_write_size.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_apis_dnr_startup_cache_write_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.performance_clone_deserialize_size.count, metrics.memory_distribution.performance_clone_deserialize_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.performance_clone_deserialize_size.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_clone_deserialize_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.browser_backup_total_backup_size.count, metrics.memory_distribution.browser_backup_total_backup_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.browser_backup_total_backup_size.values) AS `values`
                                ) AS `values`
                            
                                ) AS `browser_backup_total_backup_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.browser_backup_compressed_archive_size.count, metrics.memory_distribution.browser_backup_compressed_archive_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.browser_backup_compressed_archive_size.values) AS `values`
                                ) AS `values`
                            
                                ) AS `browser_backup_compressed_archive_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.networking_cache_metadata_size.count, metrics.memory_distribution.networking_cache_metadata_size.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.networking_cache_metadata_size.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cache_metadata_size`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.cert_storage_memory.count, metrics.memory_distribution.cert_storage_memory.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.cert_storage_memory.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_storage_memory`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.networking_http_3_udp_datagram_segment_size_received.count, metrics.memory_distribution.networking_http_3_udp_datagram_segment_size_received.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.networking_http_3_udp_datagram_segment_size_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_udp_datagram_segment_size_received`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.networking_http_3_udp_datagram_segment_size_sent.count, metrics.memory_distribution.networking_http_3_udp_datagram_segment_size_sent.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.networking_http_3_udp_datagram_segment_size_sent.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_udp_datagram_segment_size_sent`
                            , 
                                STRUCT(
                                    metrics.memory_distribution.networking_http_3_udp_datagram_size_received.count, metrics.memory_distribution.networking_http_3_udp_datagram_size_received.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.memory_distribution.networking_http_3_udp_datagram_size_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_udp_datagram_size_received`
                            
                                ) AS `memory_distribution`
                            , 
                                STRUCT(
                                    metrics.string.ping_reason, metrics.string.geckoview_validation_build_id, metrics.string.geckoview_validation_version, metrics.string.search_engine_default_display_name, metrics.string.search_engine_default_engine_id, metrics.string.search_engine_default_load_path, metrics.string.search_engine_default_verified, metrics.string.search_engine_private_display_name, metrics.string.search_engine_private_engine_id, metrics.string.search_engine_private_load_path, metrics.string.search_engine_private_verified, metrics.string.blocklist_mlbf_source, metrics.string.extensions_quarantined_domains_listhash, metrics.string.extensions_quarantined_domains_remotehash, metrics.string.glean_client_annotation_experimentation_id, metrics.string.glean_database_rkv_load_error, metrics.string.gpu_process_feature_status, metrics.string.gfx_adapter_primary_description, metrics.string.gfx_adapter_primary_device_id, metrics.string.gfx_adapter_primary_driver_date, metrics.string.gfx_adapter_primary_driver_files, metrics.string.gfx_adapter_primary_driver_vendor, metrics.string.gfx_adapter_primary_driver_version, metrics.string.gfx_adapter_primary_subsystem_id, metrics.string.gfx_adapter_primary_vendor_id, metrics.string.gfx_feature_webrender, metrics.string.gfx_status_compositor, metrics.string.gfx_status_last_compositor_gecko_version, metrics.string.gecko_build_id, metrics.string.gecko_version, metrics.string.installation_first_seen_failure_reason, metrics.string.installation_first_seen_installer_type, metrics.string.installation_first_seen_version, metrics.string.genai_chatbot_provider, metrics.string.sidebar_display_settings, metrics.string.sidebar_position_settings, metrics.string.sidebar_tabs_layout, metrics.string.blocklist_mlbf_softblocks_source, metrics.string.a11y_instantiators, metrics.string.gfx_linux_window_protocol, metrics.string.os_environment_allowed_app_sources, metrics.string.os_environment_launch_method, metrics.string.startup_profile_database_version, metrics.string.startup_profile_selection_reason, metrics.string.widget_gtk_version
                                ) AS `string`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metrics.timespan.fog_initialization.time_unit, metrics.timespan.fog_initialization.value
                                ) AS `fog_initialization`
                            , 
                                STRUCT(
                                    metrics.timespan.extensions_startup_cache_load_time.time_unit, metrics.timespan.extensions_startup_cache_load_time.value
                                ) AS `extensions_startup_cache_load_time`
                            , 
                                STRUCT(
                                    metrics.timespan.migration_time_to_produce_migrator_list.time_unit, metrics.timespan.migration_time_to_produce_migrator_list.value
                                ) AS `migration_time_to_produce_migrator_list`
                            , 
                                STRUCT(
                                    metrics.timespan.networking_loading_certs_task.time_unit, metrics.timespan.networking_loading_certs_task.value
                                ) AS `networking_loading_certs_task`
                            , 
                                STRUCT(
                                    metrics.timespan.networking_nss_initialization.time_unit, metrics.timespan.networking_nss_initialization.value
                                ) AS `networking_nss_initialization`
                            
                                ) AS `timespan`
                            , 
                                STRUCT(
                                    metrics.datetime.glean_validation_first_run_hour, metrics.datetime.background_update_time_last_update_scheduled, metrics.datetime.blocklist_last_modified_rs_addons_mblf, metrics.datetime.blocklist_mlbf_generation_time, metrics.datetime.blocklist_mlbf_stash_time_newest, metrics.datetime.blocklist_mlbf_stash_time_oldest, metrics.datetime.blocklist_mlbf_softblocks_generation_time
                                ) AS `datetime`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metrics.timing_distribution.fog_ipc_flush_durations.bucket_count, metrics.timing_distribution.fog_ipc_flush_durations.histogram_type, metrics.timing_distribution.fog_ipc_flush_durations.overflow, metrics.timing_distribution.fog_ipc_flush_durations.range, metrics.timing_distribution.fog_ipc_flush_durations.sum, metrics.timing_distribution.fog_ipc_flush_durations.time_unit, metrics.timing_distribution.fog_ipc_flush_durations.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.fog_ipc_flush_durations.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.fog_ipc_flush_durations.count
                                ) AS `fog_ipc_flush_durations`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.paint_build_displaylist_time.bucket_count, metrics.timing_distribution.paint_build_displaylist_time.histogram_type, metrics.timing_distribution.paint_build_displaylist_time.overflow, metrics.timing_distribution.paint_build_displaylist_time.range, metrics.timing_distribution.paint_build_displaylist_time.sum, metrics.timing_distribution.paint_build_displaylist_time.time_unit, metrics.timing_distribution.paint_build_displaylist_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.paint_build_displaylist_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.paint_build_displaylist_time.count
                                ) AS `paint_build_displaylist_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_rasterize_glyphs_time.bucket_count, metrics.timing_distribution.wr_rasterize_glyphs_time.histogram_type, metrics.timing_distribution.wr_rasterize_glyphs_time.overflow, metrics.timing_distribution.wr_rasterize_glyphs_time.range, metrics.timing_distribution.wr_rasterize_glyphs_time.sum, metrics.timing_distribution.wr_rasterize_glyphs_time.time_unit, metrics.timing_distribution.wr_rasterize_glyphs_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_rasterize_glyphs_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_rasterize_glyphs_time.count
                                ) AS `wr_rasterize_glyphs_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_framebuild_time.bucket_count, metrics.timing_distribution.wr_framebuild_time.histogram_type, metrics.timing_distribution.wr_framebuild_time.overflow, metrics.timing_distribution.wr_framebuild_time.range, metrics.timing_distribution.wr_framebuild_time.sum, metrics.timing_distribution.wr_framebuild_time.time_unit, metrics.timing_distribution.wr_framebuild_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_framebuild_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_framebuild_time.count
                                ) AS `wr_framebuild_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_scenebuild_time.bucket_count, metrics.timing_distribution.wr_scenebuild_time.histogram_type, metrics.timing_distribution.wr_scenebuild_time.overflow, metrics.timing_distribution.wr_scenebuild_time.range, metrics.timing_distribution.wr_scenebuild_time.sum, metrics.timing_distribution.wr_scenebuild_time.time_unit, metrics.timing_distribution.wr_scenebuild_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_scenebuild_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_scenebuild_time.count
                                ) AS `wr_scenebuild_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_sceneswap_time.bucket_count, metrics.timing_distribution.wr_sceneswap_time.histogram_type, metrics.timing_distribution.wr_sceneswap_time.overflow, metrics.timing_distribution.wr_sceneswap_time.range, metrics.timing_distribution.wr_sceneswap_time.sum, metrics.timing_distribution.wr_sceneswap_time.time_unit, metrics.timing_distribution.wr_sceneswap_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_sceneswap_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_sceneswap_time.count
                                ) AS `wr_sceneswap_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_rasterize_blobs_time.bucket_count, metrics.timing_distribution.wr_rasterize_blobs_time.histogram_type, metrics.timing_distribution.wr_rasterize_blobs_time.overflow, metrics.timing_distribution.wr_rasterize_blobs_time.range, metrics.timing_distribution.wr_rasterize_blobs_time.sum, metrics.timing_distribution.wr_rasterize_blobs_time.time_unit, metrics.timing_distribution.wr_rasterize_blobs_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_rasterize_blobs_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_rasterize_blobs_time.count
                                ) AS `wr_rasterize_blobs_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_gpu_wait_time.bucket_count, metrics.timing_distribution.wr_gpu_wait_time.histogram_type, metrics.timing_distribution.wr_gpu_wait_time.overflow, metrics.timing_distribution.wr_gpu_wait_time.range, metrics.timing_distribution.wr_gpu_wait_time.sum, metrics.timing_distribution.wr_gpu_wait_time.time_unit, metrics.timing_distribution.wr_gpu_wait_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_gpu_wait_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_gpu_wait_time.count
                                ) AS `wr_gpu_wait_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_renderer_time.bucket_count, metrics.timing_distribution.wr_renderer_time.histogram_type, metrics.timing_distribution.wr_renderer_time.overflow, metrics.timing_distribution.wr_renderer_time.range, metrics.timing_distribution.wr_renderer_time.sum, metrics.timing_distribution.wr_renderer_time.time_unit, metrics.timing_distribution.wr_renderer_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_renderer_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_renderer_time.count
                                ) AS `wr_renderer_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_texture_cache_update_time.bucket_count, metrics.timing_distribution.wr_texture_cache_update_time.histogram_type, metrics.timing_distribution.wr_texture_cache_update_time.overflow, metrics.timing_distribution.wr_texture_cache_update_time.range, metrics.timing_distribution.wr_texture_cache_update_time.sum, metrics.timing_distribution.wr_texture_cache_update_time.time_unit, metrics.timing_distribution.wr_texture_cache_update_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_texture_cache_update_time.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_texture_cache_update_time.count
                                ) AS `wr_texture_cache_update_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_time_to_frame_build.bucket_count, metrics.timing_distribution.wr_time_to_frame_build.histogram_type, metrics.timing_distribution.wr_time_to_frame_build.overflow, metrics.timing_distribution.wr_time_to_frame_build.range, metrics.timing_distribution.wr_time_to_frame_build.sum, metrics.timing_distribution.wr_time_to_frame_build.time_unit, metrics.timing_distribution.wr_time_to_frame_build.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_time_to_frame_build.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_time_to_frame_build.count
                                ) AS `wr_time_to_frame_build`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_time_to_render_start.bucket_count, metrics.timing_distribution.wr_time_to_render_start.histogram_type, metrics.timing_distribution.wr_time_to_render_start.overflow, metrics.timing_distribution.wr_time_to_render_start.range, metrics.timing_distribution.wr_time_to_render_start.sum, metrics.timing_distribution.wr_time_to_render_start.time_unit, metrics.timing_distribution.wr_time_to_render_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_time_to_render_start.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_time_to_render_start.count
                                ) AS `wr_time_to_render_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.wr_renderer_time_no_sc.bucket_count, metrics.timing_distribution.wr_renderer_time_no_sc.histogram_type, metrics.timing_distribution.wr_renderer_time_no_sc.overflow, metrics.timing_distribution.wr_renderer_time_no_sc.range, metrics.timing_distribution.wr_renderer_time_no_sc.sum, metrics.timing_distribution.wr_renderer_time_no_sc.time_unit, metrics.timing_distribution.wr_renderer_time_no_sc.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.wr_renderer_time_no_sc.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.wr_renderer_time_no_sc.count
                                ) AS `wr_renderer_time_no_sc`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_open_to_transaction_pending.bucket_count, metrics.timing_distribution.network_open_to_transaction_pending.histogram_type, metrics.timing_distribution.network_open_to_transaction_pending.overflow, metrics.timing_distribution.network_open_to_transaction_pending.range, metrics.timing_distribution.network_open_to_transaction_pending.sum, metrics.timing_distribution.network_open_to_transaction_pending.time_unit, metrics.timing_distribution.network_open_to_transaction_pending.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_open_to_transaction_pending.values) AS `values`
                                ) AS `values`
                            , metrics.timing_distribution.network_open_to_transaction_pending.count
                                ) AS `network_open_to_transaction_pending`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.cookie_banners_click_handle_duration.bucket_count, metrics.timing_distribution.cookie_banners_click_handle_duration.count, metrics.timing_distribution.cookie_banners_click_handle_duration.histogram_type, metrics.timing_distribution.cookie_banners_click_handle_duration.overflow, metrics.timing_distribution.cookie_banners_click_handle_duration.range, metrics.timing_distribution.cookie_banners_click_handle_duration.sum, metrics.timing_distribution.cookie_banners_click_handle_duration.time_unit, metrics.timing_distribution.cookie_banners_click_handle_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.cookie_banners_click_handle_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cookie_banners_click_handle_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.glean_upload_send_failure.bucket_count, metrics.timing_distribution.glean_upload_send_failure.count, metrics.timing_distribution.glean_upload_send_failure.histogram_type, metrics.timing_distribution.glean_upload_send_failure.overflow, metrics.timing_distribution.glean_upload_send_failure.range, metrics.timing_distribution.glean_upload_send_failure.sum, metrics.timing_distribution.glean_upload_send_failure.time_unit, metrics.timing_distribution.glean_upload_send_failure.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.glean_upload_send_failure.values) AS `values`
                                ) AS `values`
                            
                                ) AS `glean_upload_send_failure`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.glean_upload_send_success.bucket_count, metrics.timing_distribution.glean_upload_send_success.count, metrics.timing_distribution.glean_upload_send_success.histogram_type, metrics.timing_distribution.glean_upload_send_success.overflow, metrics.timing_distribution.glean_upload_send_success.range, metrics.timing_distribution.glean_upload_send_success.sum, metrics.timing_distribution.glean_upload_send_success.time_unit, metrics.timing_distribution.glean_upload_send_success.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.glean_upload_send_success.values) AS `values`
                                ) AS `values`
                            
                                ) AS `glean_upload_send_success`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.glean_validation_shutdown_wait.bucket_count, metrics.timing_distribution.glean_validation_shutdown_wait.count, metrics.timing_distribution.glean_validation_shutdown_wait.histogram_type, metrics.timing_distribution.glean_validation_shutdown_wait.overflow, metrics.timing_distribution.glean_validation_shutdown_wait.range, metrics.timing_distribution.glean_validation_shutdown_wait.sum, metrics.timing_distribution.glean_validation_shutdown_wait.time_unit, metrics.timing_distribution.glean_validation_shutdown_wait.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.glean_validation_shutdown_wait.values) AS `values`
                                ) AS `values`
                            
                                ) AS `glean_validation_shutdown_wait`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.bucket_count, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.count, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.histogram_type, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.overflow, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.range, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.sum, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.time_unit, metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_apis_dnr_evaluate_rules_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_apis_dnr_evaluate_rules_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.bucket_count, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.count, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.histogram_type, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.overflow, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.range, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.sum, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.time_unit, metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_apis_dnr_startup_cache_read_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_apis_dnr_startup_cache_read_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.bucket_count, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.count, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.histogram_type, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.overflow, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.range, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.sum, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.time_unit, metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_apis_dnr_startup_cache_write_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_apis_dnr_startup_cache_write_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.bucket_count, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.count, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.histogram_type, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.overflow, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.range, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.sum, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.time_unit, metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_apis_dnr_validate_rules_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_apis_dnr_validate_rules_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.bucket_count, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.count, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.histogram_type, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.overflow, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.range, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.sum, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.time_unit, metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.glean_validation_shutdown_dispatcher_wait.values) AS `values`
                                ) AS `values`
                            
                                ) AS `glean_validation_shutdown_dispatcher_wait`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.serp_categorization_duration.bucket_count, metrics.timing_distribution.serp_categorization_duration.count, metrics.timing_distribution.serp_categorization_duration.histogram_type, metrics.timing_distribution.serp_categorization_duration.overflow, metrics.timing_distribution.serp_categorization_duration.range, metrics.timing_distribution.serp_categorization_duration.sum, metrics.timing_distribution.serp_categorization_duration.time_unit, metrics.timing_distribution.serp_categorization_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.serp_categorization_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `serp_categorization_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.search_service_startup_time.bucket_count, metrics.timing_distribution.search_service_startup_time.count, metrics.timing_distribution.search_service_startup_time.histogram_type, metrics.timing_distribution.search_service_startup_time.overflow, metrics.timing_distribution.search_service_startup_time.range, metrics.timing_distribution.search_service_startup_time.sum, metrics.timing_distribution.search_service_startup_time.time_unit, metrics.timing_distribution.search_service_startup_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.search_service_startup_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `search_service_startup_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_dns_failed_lookup_time.bucket_count, metrics.timing_distribution.networking_dns_failed_lookup_time.count, metrics.timing_distribution.networking_dns_failed_lookup_time.histogram_type, metrics.timing_distribution.networking_dns_failed_lookup_time.overflow, metrics.timing_distribution.networking_dns_failed_lookup_time.range, metrics.timing_distribution.networking_dns_failed_lookup_time.sum, metrics.timing_distribution.networking_dns_failed_lookup_time.time_unit, metrics.timing_distribution.networking_dns_failed_lookup_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_dns_failed_lookup_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_dns_failed_lookup_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_dns_lookup_time.bucket_count, metrics.timing_distribution.networking_dns_lookup_time.count, metrics.timing_distribution.networking_dns_lookup_time.histogram_type, metrics.timing_distribution.networking_dns_lookup_time.overflow, metrics.timing_distribution.networking_dns_lookup_time.range, metrics.timing_distribution.networking_dns_lookup_time.sum, metrics.timing_distribution.networking_dns_lookup_time.time_unit, metrics.timing_distribution.networking_dns_lookup_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_dns_lookup_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_dns_lookup_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_dns_renewal_time.bucket_count, metrics.timing_distribution.networking_dns_renewal_time.count, metrics.timing_distribution.networking_dns_renewal_time.histogram_type, metrics.timing_distribution.networking_dns_renewal_time.overflow, metrics.timing_distribution.networking_dns_renewal_time.range, metrics.timing_distribution.networking_dns_renewal_time.sum, metrics.timing_distribution.networking_dns_renewal_time.time_unit, metrics.timing_distribution.networking_dns_renewal_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_dns_renewal_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_dns_renewal_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_dns_renewal_time_for_ttl.bucket_count, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.count, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.histogram_type, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.overflow, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.range, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.sum, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.time_unit, metrics.timing_distribution.networking_dns_renewal_time_for_ttl.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_dns_renewal_time_for_ttl.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_dns_renewal_time_for_ttl`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.bucket_count, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.count, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.histogram_type, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.overflow, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.range, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.sum, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.time_unit, metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.fingerprinting_protection_canvas_noise_calculate_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `fingerprinting_protection_canvas_noise_calculate_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_onstart_delay.bucket_count, metrics.timing_distribution.networking_http_content_onstart_delay.count, metrics.timing_distribution.networking_http_content_onstart_delay.histogram_type, metrics.timing_distribution.networking_http_content_onstart_delay.overflow, metrics.timing_distribution.networking_http_content_onstart_delay.range, metrics.timing_distribution.networking_http_content_onstart_delay.sum, metrics.timing_distribution.networking_http_content_onstart_delay.time_unit, metrics.timing_distribution.networking_http_content_onstart_delay.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_onstart_delay.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_onstart_delay`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_onstop_delay.bucket_count, metrics.timing_distribution.networking_http_content_onstop_delay.count, metrics.timing_distribution.networking_http_content_onstop_delay.histogram_type, metrics.timing_distribution.networking_http_content_onstop_delay.overflow, metrics.timing_distribution.networking_http_content_onstop_delay.range, metrics.timing_distribution.networking_http_content_onstop_delay.sum, metrics.timing_distribution.networking_http_content_onstop_delay.time_unit, metrics.timing_distribution.networking_http_content_onstop_delay.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_onstop_delay.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_onstop_delay`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.fog_validation_gvsv_composite_time.bucket_count, metrics.timing_distribution.fog_validation_gvsv_composite_time.count, metrics.timing_distribution.fog_validation_gvsv_composite_time.histogram_type, metrics.timing_distribution.fog_validation_gvsv_composite_time.overflow, metrics.timing_distribution.fog_validation_gvsv_composite_time.range, metrics.timing_distribution.fog_validation_gvsv_composite_time.sum, metrics.timing_distribution.fog_validation_gvsv_composite_time.time_unit, metrics.timing_distribution.fog_validation_gvsv_composite_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.fog_validation_gvsv_composite_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `fog_validation_gvsv_composite_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.bucket_count, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.count, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.histogram_type, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.overflow, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.range, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.sum, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.time_unit, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_html5parser_ondatafinished_to_onstop_delay`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.bucket_count, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.count, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.histogram_type, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.overflow, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.range, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.sum, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.time_unit, metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_html5parser_ondatafinished_to_onstop_delay_negative`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_ondatafinished_delay.bucket_count, metrics.timing_distribution.networking_http_content_ondatafinished_delay.count, metrics.timing_distribution.networking_http_content_ondatafinished_delay.histogram_type, metrics.timing_distribution.networking_http_content_ondatafinished_delay.overflow, metrics.timing_distribution.networking_http_content_ondatafinished_delay.range, metrics.timing_distribution.networking_http_content_ondatafinished_delay.sum, metrics.timing_distribution.networking_http_content_ondatafinished_delay.time_unit, metrics.timing_distribution.networking_http_content_ondatafinished_delay.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_ondatafinished_delay.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_ondatafinished_delay`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.bucket_count, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.count, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.histogram_type, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.overflow, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.range, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.sum, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.time_unit, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_ondatafinished_to_onstop_delay`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.bucket_count, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.count, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.histogram_type, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.overflow, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.range, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.sum, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.time_unit, metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_ondatafinished_to_onstop_delay_negative.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_ondatafinished_to_onstop_delay_negative`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.perf_largest_contentful_paint.bucket_count, metrics.timing_distribution.perf_largest_contentful_paint.count, metrics.timing_distribution.perf_largest_contentful_paint.histogram_type, metrics.timing_distribution.perf_largest_contentful_paint.overflow, metrics.timing_distribution.perf_largest_contentful_paint.range, metrics.timing_distribution.perf_largest_contentful_paint.sum, metrics.timing_distribution.perf_largest_contentful_paint.time_unit, metrics.timing_distribution.perf_largest_contentful_paint.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.perf_largest_contentful_paint.values) AS `values`
                                ) AS `values`
                            
                                ) AS `perf_largest_contentful_paint`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.bucket_count, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.count, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.histogram_type, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.overflow, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.range, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.sum, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.time_unit, metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.perf_largest_contentful_paint_from_response_start.values) AS `values`
                                ) AS `values`
                            
                                ) AS `perf_largest_contentful_paint_from_response_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_background_page_load.bucket_count, metrics.timing_distribution.extensions_timing_background_page_load.count, metrics.timing_distribution.extensions_timing_background_page_load.histogram_type, metrics.timing_distribution.extensions_timing_background_page_load.overflow, metrics.timing_distribution.extensions_timing_background_page_load.range, metrics.timing_distribution.extensions_timing_background_page_load.sum, metrics.timing_distribution.extensions_timing_background_page_load.time_unit, metrics.timing_distribution.extensions_timing_background_page_load.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_background_page_load.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_background_page_load`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_browser_action_popup_open.bucket_count, metrics.timing_distribution.extensions_timing_browser_action_popup_open.count, metrics.timing_distribution.extensions_timing_browser_action_popup_open.histogram_type, metrics.timing_distribution.extensions_timing_browser_action_popup_open.overflow, metrics.timing_distribution.extensions_timing_browser_action_popup_open.range, metrics.timing_distribution.extensions_timing_browser_action_popup_open.sum, metrics.timing_distribution.extensions_timing_browser_action_popup_open.time_unit, metrics.timing_distribution.extensions_timing_browser_action_popup_open.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_browser_action_popup_open.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_browser_action_popup_open`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_content_script_injection.bucket_count, metrics.timing_distribution.extensions_timing_content_script_injection.count, metrics.timing_distribution.extensions_timing_content_script_injection.histogram_type, metrics.timing_distribution.extensions_timing_content_script_injection.overflow, metrics.timing_distribution.extensions_timing_content_script_injection.range, metrics.timing_distribution.extensions_timing_content_script_injection.sum, metrics.timing_distribution.extensions_timing_content_script_injection.time_unit, metrics.timing_distribution.extensions_timing_content_script_injection.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_content_script_injection.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_content_script_injection`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_extension_startup.bucket_count, metrics.timing_distribution.extensions_timing_extension_startup.count, metrics.timing_distribution.extensions_timing_extension_startup.histogram_type, metrics.timing_distribution.extensions_timing_extension_startup.overflow, metrics.timing_distribution.extensions_timing_extension_startup.range, metrics.timing_distribution.extensions_timing_extension_startup.sum, metrics.timing_distribution.extensions_timing_extension_startup.time_unit, metrics.timing_distribution.extensions_timing_extension_startup.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_extension_startup.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_extension_startup`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_page_action_popup_open.bucket_count, metrics.timing_distribution.extensions_timing_page_action_popup_open.count, metrics.timing_distribution.extensions_timing_page_action_popup_open.histogram_type, metrics.timing_distribution.extensions_timing_page_action_popup_open.overflow, metrics.timing_distribution.extensions_timing_page_action_popup_open.range, metrics.timing_distribution.extensions_timing_page_action_popup_open.sum, metrics.timing_distribution.extensions_timing_page_action_popup_open.time_unit, metrics.timing_distribution.extensions_timing_page_action_popup_open.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_page_action_popup_open.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_page_action_popup_open`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_storage_local_get_idb.bucket_count, metrics.timing_distribution.extensions_timing_storage_local_get_idb.count, metrics.timing_distribution.extensions_timing_storage_local_get_idb.histogram_type, metrics.timing_distribution.extensions_timing_storage_local_get_idb.overflow, metrics.timing_distribution.extensions_timing_storage_local_get_idb.range, metrics.timing_distribution.extensions_timing_storage_local_get_idb.sum, metrics.timing_distribution.extensions_timing_storage_local_get_idb.time_unit, metrics.timing_distribution.extensions_timing_storage_local_get_idb.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_storage_local_get_idb.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_storage_local_get_idb`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_storage_local_get_json.bucket_count, metrics.timing_distribution.extensions_timing_storage_local_get_json.count, metrics.timing_distribution.extensions_timing_storage_local_get_json.histogram_type, metrics.timing_distribution.extensions_timing_storage_local_get_json.overflow, metrics.timing_distribution.extensions_timing_storage_local_get_json.range, metrics.timing_distribution.extensions_timing_storage_local_get_json.sum, metrics.timing_distribution.extensions_timing_storage_local_get_json.time_unit, metrics.timing_distribution.extensions_timing_storage_local_get_json.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_storage_local_get_json.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_storage_local_get_json`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_storage_local_set_idb.bucket_count, metrics.timing_distribution.extensions_timing_storage_local_set_idb.count, metrics.timing_distribution.extensions_timing_storage_local_set_idb.histogram_type, metrics.timing_distribution.extensions_timing_storage_local_set_idb.overflow, metrics.timing_distribution.extensions_timing_storage_local_set_idb.range, metrics.timing_distribution.extensions_timing_storage_local_set_idb.sum, metrics.timing_distribution.extensions_timing_storage_local_set_idb.time_unit, metrics.timing_distribution.extensions_timing_storage_local_set_idb.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_storage_local_set_idb.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_storage_local_set_idb`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.extensions_timing_storage_local_set_json.bucket_count, metrics.timing_distribution.extensions_timing_storage_local_set_json.count, metrics.timing_distribution.extensions_timing_storage_local_set_json.histogram_type, metrics.timing_distribution.extensions_timing_storage_local_set_json.overflow, metrics.timing_distribution.extensions_timing_storage_local_set_json.range, metrics.timing_distribution.extensions_timing_storage_local_set_json.sum, metrics.timing_distribution.extensions_timing_storage_local_set_json.time_unit, metrics.timing_distribution.extensions_timing_storage_local_set_json.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.extensions_timing_storage_local_set_json.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_storage_local_set_json`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.cookie_banners_cmp_handle_duration.bucket_count, metrics.timing_distribution.cookie_banners_cmp_handle_duration.count, metrics.timing_distribution.cookie_banners_cmp_handle_duration.histogram_type, metrics.timing_distribution.cookie_banners_cmp_handle_duration.overflow, metrics.timing_distribution.cookie_banners_cmp_handle_duration.range, metrics.timing_distribution.cookie_banners_cmp_handle_duration.sum, metrics.timing_distribution.cookie_banners_cmp_handle_duration.time_unit, metrics.timing_distribution.cookie_banners_cmp_handle_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.cookie_banners_cmp_handle_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cookie_banners_cmp_handle_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.bucket_count, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.count, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.histogram_type, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.overflow, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.range, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.sum, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.time_unit, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_channel_page_open_to_first_sent.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_channel_page_open_to_first_sent`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.bucket_count, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.count, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.histogram_type, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.overflow, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.range, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.sum, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.time_unit, metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_channel_page_open_to_first_sent_https_rr.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_channel_page_open_to_first_sent_https_rr`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.bucket_count, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.count, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.histogram_type, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.overflow, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.range, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.sum, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.time_unit, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_channel_sub_open_to_first_sent`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.bucket_count, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.count, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.histogram_type, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.overflow, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.range, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.sum, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.time_unit, metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_channel_sub_open_to_first_sent_https_rr.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_channel_sub_open_to_first_sent_https_rr`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_transaction_wait_time.bucket_count, metrics.timing_distribution.networking_transaction_wait_time.count, metrics.timing_distribution.networking_transaction_wait_time.histogram_type, metrics.timing_distribution.networking_transaction_wait_time.overflow, metrics.timing_distribution.networking_transaction_wait_time.range, metrics.timing_distribution.networking_transaction_wait_time.sum, metrics.timing_distribution.networking_transaction_wait_time.time_unit, metrics.timing_distribution.networking_transaction_wait_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_transaction_wait_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_transaction_wait_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_transaction_wait_time_https_rr.bucket_count, metrics.timing_distribution.networking_transaction_wait_time_https_rr.count, metrics.timing_distribution.networking_transaction_wait_time_https_rr.histogram_type, metrics.timing_distribution.networking_transaction_wait_time_https_rr.overflow, metrics.timing_distribution.networking_transaction_wait_time_https_rr.range, metrics.timing_distribution.networking_transaction_wait_time_https_rr.sum, metrics.timing_distribution.networking_transaction_wait_time_https_rr.time_unit, metrics.timing_distribution.networking_transaction_wait_time_https_rr.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_transaction_wait_time_https_rr.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_transaction_wait_time_https_rr`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.privacy_sanitize_load_time.bucket_count, metrics.timing_distribution.privacy_sanitize_load_time.count, metrics.timing_distribution.privacy_sanitize_load_time.histogram_type, metrics.timing_distribution.privacy_sanitize_load_time.overflow, metrics.timing_distribution.privacy_sanitize_load_time.range, metrics.timing_distribution.privacy_sanitize_load_time.sum, metrics.timing_distribution.privacy_sanitize_load_time.time_unit, metrics.timing_distribution.privacy_sanitize_load_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.privacy_sanitize_load_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `privacy_sanitize_load_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.gfx_checkerboard_duration.bucket_count, metrics.timing_distribution.gfx_checkerboard_duration.count, metrics.timing_distribution.gfx_checkerboard_duration.histogram_type, metrics.timing_distribution.gfx_checkerboard_duration.overflow, metrics.timing_distribution.gfx_checkerboard_duration.range, metrics.timing_distribution.gfx_checkerboard_duration.sum, metrics.timing_distribution.gfx_checkerboard_duration.time_unit, metrics.timing_distribution.gfx_checkerboard_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.gfx_checkerboard_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_checkerboard_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.gfx_checkerboard_potential_duration.bucket_count, metrics.timing_distribution.gfx_checkerboard_potential_duration.count, metrics.timing_distribution.gfx_checkerboard_potential_duration.histogram_type, metrics.timing_distribution.gfx_checkerboard_potential_duration.overflow, metrics.timing_distribution.gfx_checkerboard_potential_duration.range, metrics.timing_distribution.gfx_checkerboard_potential_duration.sum, metrics.timing_distribution.gfx_checkerboard_potential_duration.time_unit, metrics.timing_distribution.gfx_checkerboard_potential_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.gfx_checkerboard_potential_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_checkerboard_potential_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.gfx_composite_time.bucket_count, metrics.timing_distribution.gfx_composite_time.count, metrics.timing_distribution.gfx_composite_time.histogram_type, metrics.timing_distribution.gfx_composite_time.overflow, metrics.timing_distribution.gfx_composite_time.range, metrics.timing_distribution.gfx_composite_time.sum, metrics.timing_distribution.gfx_composite_time.time_unit, metrics.timing_distribution.gfx_composite_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.gfx_composite_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_composite_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.gfx_content_full_paint_time.bucket_count, metrics.timing_distribution.gfx_content_full_paint_time.count, metrics.timing_distribution.gfx_content_full_paint_time.histogram_type, metrics.timing_distribution.gfx_content_full_paint_time.overflow, metrics.timing_distribution.gfx_content_full_paint_time.range, metrics.timing_distribution.gfx_content_full_paint_time.sum, metrics.timing_distribution.gfx_content_full_paint_time.time_unit, metrics.timing_distribution.gfx_content_full_paint_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.gfx_content_full_paint_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_full_paint_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.gfx_content_paint_time.bucket_count, metrics.timing_distribution.gfx_content_paint_time.count, metrics.timing_distribution.gfx_content_paint_time.histogram_type, metrics.timing_distribution.gfx_content_paint_time.overflow, metrics.timing_distribution.gfx_content_paint_time.range, metrics.timing_distribution.gfx_content_paint_time.sum, metrics.timing_distribution.gfx_content_paint_time.time_unit, metrics.timing_distribution.gfx_content_paint_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.gfx_content_paint_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_paint_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.gfx_scroll_present_latency.bucket_count, metrics.timing_distribution.gfx_scroll_present_latency.count, metrics.timing_distribution.gfx_scroll_present_latency.histogram_type, metrics.timing_distribution.gfx_scroll_present_latency.overflow, metrics.timing_distribution.gfx_scroll_present_latency.range, metrics.timing_distribution.gfx_scroll_present_latency.sum, metrics.timing_distribution.gfx_scroll_present_latency.time_unit, metrics.timing_distribution.gfx_scroll_present_latency.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.gfx_scroll_present_latency.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_scroll_present_latency`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_cache_hit_time.bucket_count, metrics.timing_distribution.network_cache_hit_time.count, metrics.timing_distribution.network_cache_hit_time.histogram_type, metrics.timing_distribution.network_cache_hit_time.overflow, metrics.timing_distribution.network_cache_hit_time.range, metrics.timing_distribution.network_cache_hit_time.sum, metrics.timing_distribution.network_cache_hit_time.time_unit, metrics.timing_distribution.network_cache_hit_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_cache_hit_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_cache_hit_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_dns_end.bucket_count, metrics.timing_distribution.network_dns_end.count, metrics.timing_distribution.network_dns_end.histogram_type, metrics.timing_distribution.network_dns_end.overflow, metrics.timing_distribution.network_dns_end.range, metrics.timing_distribution.network_dns_end.sum, metrics.timing_distribution.network_dns_end.time_unit, metrics.timing_distribution.network_dns_end.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_dns_end.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_dns_end`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_dns_start.bucket_count, metrics.timing_distribution.network_dns_start.count, metrics.timing_distribution.network_dns_start.histogram_type, metrics.timing_distribution.network_dns_start.overflow, metrics.timing_distribution.network_dns_start.range, metrics.timing_distribution.network_dns_start.sum, metrics.timing_distribution.network_dns_start.time_unit, metrics.timing_distribution.network_dns_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_dns_start.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_dns_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_first_from_cache.bucket_count, metrics.timing_distribution.network_first_from_cache.count, metrics.timing_distribution.network_first_from_cache.histogram_type, metrics.timing_distribution.network_first_from_cache.overflow, metrics.timing_distribution.network_first_from_cache.range, metrics.timing_distribution.network_first_from_cache.sum, metrics.timing_distribution.network_first_from_cache.time_unit, metrics.timing_distribution.network_first_from_cache.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_first_from_cache.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_first_from_cache`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_font_download_end.bucket_count, metrics.timing_distribution.network_font_download_end.count, metrics.timing_distribution.network_font_download_end.histogram_type, metrics.timing_distribution.network_font_download_end.overflow, metrics.timing_distribution.network_font_download_end.range, metrics.timing_distribution.network_font_download_end.sum, metrics.timing_distribution.network_font_download_end.time_unit, metrics.timing_distribution.network_font_download_end.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_font_download_end.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_font_download_end`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_tcp_connection.bucket_count, metrics.timing_distribution.network_tcp_connection.count, metrics.timing_distribution.network_tcp_connection.histogram_type, metrics.timing_distribution.network_tcp_connection.overflow, metrics.timing_distribution.network_tcp_connection.range, metrics.timing_distribution.network_tcp_connection.sum, metrics.timing_distribution.network_tcp_connection.time_unit, metrics.timing_distribution.network_tcp_connection.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_tcp_connection.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_tcp_connection`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_tls_handshake.bucket_count, metrics.timing_distribution.network_tls_handshake.count, metrics.timing_distribution.network_tls_handshake.histogram_type, metrics.timing_distribution.network_tls_handshake.overflow, metrics.timing_distribution.network_tls_handshake.range, metrics.timing_distribution.network_tls_handshake.sum, metrics.timing_distribution.network_tls_handshake.time_unit, metrics.timing_distribution.network_tls_handshake.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_tls_handshake.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_tls_handshake`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_baseline_compile_time.bucket_count, metrics.timing_distribution.javascript_pageload_baseline_compile_time.count, metrics.timing_distribution.javascript_pageload_baseline_compile_time.histogram_type, metrics.timing_distribution.javascript_pageload_baseline_compile_time.overflow, metrics.timing_distribution.javascript_pageload_baseline_compile_time.range, metrics.timing_distribution.javascript_pageload_baseline_compile_time.sum, metrics.timing_distribution.javascript_pageload_baseline_compile_time.time_unit, metrics.timing_distribution.javascript_pageload_baseline_compile_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_baseline_compile_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_baseline_compile_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_delazification_time.bucket_count, metrics.timing_distribution.javascript_pageload_delazification_time.count, metrics.timing_distribution.javascript_pageload_delazification_time.histogram_type, metrics.timing_distribution.javascript_pageload_delazification_time.overflow, metrics.timing_distribution.javascript_pageload_delazification_time.range, metrics.timing_distribution.javascript_pageload_delazification_time.sum, metrics.timing_distribution.javascript_pageload_delazification_time.time_unit, metrics.timing_distribution.javascript_pageload_delazification_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_delazification_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_delazification_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_execution_time.bucket_count, metrics.timing_distribution.javascript_pageload_execution_time.count, metrics.timing_distribution.javascript_pageload_execution_time.histogram_type, metrics.timing_distribution.javascript_pageload_execution_time.overflow, metrics.timing_distribution.javascript_pageload_execution_time.range, metrics.timing_distribution.javascript_pageload_execution_time.sum, metrics.timing_distribution.javascript_pageload_execution_time.time_unit, metrics.timing_distribution.javascript_pageload_execution_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_execution_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_execution_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_gc_time.bucket_count, metrics.timing_distribution.javascript_pageload_gc_time.count, metrics.timing_distribution.javascript_pageload_gc_time.histogram_type, metrics.timing_distribution.javascript_pageload_gc_time.overflow, metrics.timing_distribution.javascript_pageload_gc_time.range, metrics.timing_distribution.javascript_pageload_gc_time.sum, metrics.timing_distribution.javascript_pageload_gc_time.time_unit, metrics.timing_distribution.javascript_pageload_gc_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_gc_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_gc_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_parse_time.bucket_count, metrics.timing_distribution.javascript_pageload_parse_time.count, metrics.timing_distribution.javascript_pageload_parse_time.histogram_type, metrics.timing_distribution.javascript_pageload_parse_time.overflow, metrics.timing_distribution.javascript_pageload_parse_time.range, metrics.timing_distribution.javascript_pageload_parse_time.sum, metrics.timing_distribution.javascript_pageload_parse_time.time_unit, metrics.timing_distribution.javascript_pageload_parse_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_parse_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_parse_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_protect_time.bucket_count, metrics.timing_distribution.javascript_pageload_protect_time.count, metrics.timing_distribution.javascript_pageload_protect_time.histogram_type, metrics.timing_distribution.javascript_pageload_protect_time.overflow, metrics.timing_distribution.javascript_pageload_protect_time.range, metrics.timing_distribution.javascript_pageload_protect_time.sum, metrics.timing_distribution.javascript_pageload_protect_time.time_unit, metrics.timing_distribution.javascript_pageload_protect_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_protect_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_protect_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_pageload_xdr_encode_time.bucket_count, metrics.timing_distribution.javascript_pageload_xdr_encode_time.count, metrics.timing_distribution.javascript_pageload_xdr_encode_time.histogram_type, metrics.timing_distribution.javascript_pageload_xdr_encode_time.overflow, metrics.timing_distribution.javascript_pageload_xdr_encode_time.range, metrics.timing_distribution.javascript_pageload_xdr_encode_time.sum, metrics.timing_distribution.javascript_pageload_xdr_encode_time.time_unit, metrics.timing_distribution.javascript_pageload_xdr_encode_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_pageload_xdr_encode_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_pageload_xdr_encode_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_interaction_keypress_present_latency.bucket_count, metrics.timing_distribution.performance_interaction_keypress_present_latency.count, metrics.timing_distribution.performance_interaction_keypress_present_latency.histogram_type, metrics.timing_distribution.performance_interaction_keypress_present_latency.overflow, metrics.timing_distribution.performance_interaction_keypress_present_latency.range, metrics.timing_distribution.performance_interaction_keypress_present_latency.sum, metrics.timing_distribution.performance_interaction_keypress_present_latency.time_unit, metrics.timing_distribution.performance_interaction_keypress_present_latency.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_interaction_keypress_present_latency.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_interaction_keypress_present_latency`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.bucket_count, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.count, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.histogram_type, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.overflow, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.range, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.sum, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.time_unit, metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_interaction_mouseup_click_present_latency.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_interaction_mouseup_click_present_latency`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_interaction_tab_switch_composite.bucket_count, metrics.timing_distribution.performance_interaction_tab_switch_composite.count, metrics.timing_distribution.performance_interaction_tab_switch_composite.histogram_type, metrics.timing_distribution.performance_interaction_tab_switch_composite.overflow, metrics.timing_distribution.performance_interaction_tab_switch_composite.range, metrics.timing_distribution.performance_interaction_tab_switch_composite.sum, metrics.timing_distribution.performance_interaction_tab_switch_composite.time_unit, metrics.timing_distribution.performance_interaction_tab_switch_composite.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_interaction_tab_switch_composite.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_interaction_tab_switch_composite`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_page_non_blank_paint.bucket_count, metrics.timing_distribution.performance_page_non_blank_paint.count, metrics.timing_distribution.performance_page_non_blank_paint.histogram_type, metrics.timing_distribution.performance_page_non_blank_paint.overflow, metrics.timing_distribution.performance_page_non_blank_paint.range, metrics.timing_distribution.performance_page_non_blank_paint.sum, metrics.timing_distribution.performance_page_non_blank_paint.time_unit, metrics.timing_distribution.performance_page_non_blank_paint.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_page_non_blank_paint.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_page_non_blank_paint`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_fcp.bucket_count, metrics.timing_distribution.performance_pageload_fcp.count, metrics.timing_distribution.performance_pageload_fcp.histogram_type, metrics.timing_distribution.performance_pageload_fcp.overflow, metrics.timing_distribution.performance_pageload_fcp.range, metrics.timing_distribution.performance_pageload_fcp.sum, metrics.timing_distribution.performance_pageload_fcp.time_unit, metrics.timing_distribution.performance_pageload_fcp.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_fcp.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_fcp`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_fcp_responsestart.bucket_count, metrics.timing_distribution.performance_pageload_fcp_responsestart.count, metrics.timing_distribution.performance_pageload_fcp_responsestart.histogram_type, metrics.timing_distribution.performance_pageload_fcp_responsestart.overflow, metrics.timing_distribution.performance_pageload_fcp_responsestart.range, metrics.timing_distribution.performance_pageload_fcp_responsestart.sum, metrics.timing_distribution.performance_pageload_fcp_responsestart.time_unit, metrics.timing_distribution.performance_pageload_fcp_responsestart.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_fcp_responsestart.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_fcp_responsestart`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_load_time.bucket_count, metrics.timing_distribution.performance_pageload_load_time.count, metrics.timing_distribution.performance_pageload_load_time.histogram_type, metrics.timing_distribution.performance_pageload_load_time.overflow, metrics.timing_distribution.performance_pageload_load_time.range, metrics.timing_distribution.performance_pageload_load_time.sum, metrics.timing_distribution.performance_pageload_load_time.time_unit, metrics.timing_distribution.performance_pageload_load_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_load_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_load_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_load_time_responsestart.bucket_count, metrics.timing_distribution.performance_pageload_load_time_responsestart.count, metrics.timing_distribution.performance_pageload_load_time_responsestart.histogram_type, metrics.timing_distribution.performance_pageload_load_time_responsestart.overflow, metrics.timing_distribution.performance_pageload_load_time_responsestart.range, metrics.timing_distribution.performance_pageload_load_time_responsestart.sum, metrics.timing_distribution.performance_pageload_load_time_responsestart.time_unit, metrics.timing_distribution.performance_pageload_load_time_responsestart.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_load_time_responsestart.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_load_time_responsestart`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_dom_complete.bucket_count, metrics.timing_distribution.performance_time_dom_complete.count, metrics.timing_distribution.performance_time_dom_complete.histogram_type, metrics.timing_distribution.performance_time_dom_complete.overflow, metrics.timing_distribution.performance_time_dom_complete.range, metrics.timing_distribution.performance_time_dom_complete.sum, metrics.timing_distribution.performance_time_dom_complete.time_unit, metrics.timing_distribution.performance_time_dom_complete.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_dom_complete.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_dom_complete`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_dom_content_loaded_end.bucket_count, metrics.timing_distribution.performance_time_dom_content_loaded_end.count, metrics.timing_distribution.performance_time_dom_content_loaded_end.histogram_type, metrics.timing_distribution.performance_time_dom_content_loaded_end.overflow, metrics.timing_distribution.performance_time_dom_content_loaded_end.range, metrics.timing_distribution.performance_time_dom_content_loaded_end.sum, metrics.timing_distribution.performance_time_dom_content_loaded_end.time_unit, metrics.timing_distribution.performance_time_dom_content_loaded_end.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_dom_content_loaded_end.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_dom_content_loaded_end`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_dom_content_loaded_start.bucket_count, metrics.timing_distribution.performance_time_dom_content_loaded_start.count, metrics.timing_distribution.performance_time_dom_content_loaded_start.histogram_type, metrics.timing_distribution.performance_time_dom_content_loaded_start.overflow, metrics.timing_distribution.performance_time_dom_content_loaded_start.range, metrics.timing_distribution.performance_time_dom_content_loaded_start.sum, metrics.timing_distribution.performance_time_dom_content_loaded_start.time_unit, metrics.timing_distribution.performance_time_dom_content_loaded_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_dom_content_loaded_start.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_dom_content_loaded_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_dom_interactive.bucket_count, metrics.timing_distribution.performance_time_dom_interactive.count, metrics.timing_distribution.performance_time_dom_interactive.histogram_type, metrics.timing_distribution.performance_time_dom_interactive.overflow, metrics.timing_distribution.performance_time_dom_interactive.range, metrics.timing_distribution.performance_time_dom_interactive.sum, metrics.timing_distribution.performance_time_dom_interactive.time_unit, metrics.timing_distribution.performance_time_dom_interactive.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_dom_interactive.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_dom_interactive`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_load_event_end.bucket_count, metrics.timing_distribution.performance_time_load_event_end.count, metrics.timing_distribution.performance_time_load_event_end.histogram_type, metrics.timing_distribution.performance_time_load_event_end.overflow, metrics.timing_distribution.performance_time_load_event_end.range, metrics.timing_distribution.performance_time_load_event_end.sum, metrics.timing_distribution.performance_time_load_event_end.time_unit, metrics.timing_distribution.performance_time_load_event_end.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_load_event_end.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_load_event_end`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_load_event_start.bucket_count, metrics.timing_distribution.performance_time_load_event_start.count, metrics.timing_distribution.performance_time_load_event_start.histogram_type, metrics.timing_distribution.performance_time_load_event_start.overflow, metrics.timing_distribution.performance_time_load_event_start.range, metrics.timing_distribution.performance_time_load_event_start.sum, metrics.timing_distribution.performance_time_load_event_start.time_unit, metrics.timing_distribution.performance_time_load_event_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_load_event_start.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_load_event_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.geckoview_content_process_lifetime.bucket_count, metrics.timing_distribution.geckoview_content_process_lifetime.count, metrics.timing_distribution.geckoview_content_process_lifetime.histogram_type, metrics.timing_distribution.geckoview_content_process_lifetime.overflow, metrics.timing_distribution.geckoview_content_process_lifetime.range, metrics.timing_distribution.geckoview_content_process_lifetime.sum, metrics.timing_distribution.geckoview_content_process_lifetime.time_unit, metrics.timing_distribution.geckoview_content_process_lifetime.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.geckoview_content_process_lifetime.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_content_process_lifetime`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.geckoview_page_load_progress_time.bucket_count, metrics.timing_distribution.geckoview_page_load_progress_time.count, metrics.timing_distribution.geckoview_page_load_progress_time.histogram_type, metrics.timing_distribution.geckoview_page_load_progress_time.overflow, metrics.timing_distribution.geckoview_page_load_progress_time.range, metrics.timing_distribution.geckoview_page_load_progress_time.sum, metrics.timing_distribution.geckoview_page_load_progress_time.time_unit, metrics.timing_distribution.geckoview_page_load_progress_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.geckoview_page_load_progress_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_page_load_progress_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.geckoview_page_load_time.bucket_count, metrics.timing_distribution.geckoview_page_load_time.count, metrics.timing_distribution.geckoview_page_load_time.histogram_type, metrics.timing_distribution.geckoview_page_load_time.overflow, metrics.timing_distribution.geckoview_page_load_time.range, metrics.timing_distribution.geckoview_page_load_time.sum, metrics.timing_distribution.geckoview_page_load_time.time_unit, metrics.timing_distribution.geckoview_page_load_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.geckoview_page_load_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_page_load_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.geckoview_page_reload_time.bucket_count, metrics.timing_distribution.geckoview_page_reload_time.count, metrics.timing_distribution.geckoview_page_reload_time.histogram_type, metrics.timing_distribution.geckoview_page_reload_time.overflow, metrics.timing_distribution.geckoview_page_reload_time.range, metrics.timing_distribution.geckoview_page_reload_time.sum, metrics.timing_distribution.geckoview_page_reload_time.time_unit, metrics.timing_distribution.geckoview_page_reload_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.geckoview_page_reload_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_page_reload_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.geckoview_startup_runtime.bucket_count, metrics.timing_distribution.geckoview_startup_runtime.count, metrics.timing_distribution.geckoview_startup_runtime.histogram_type, metrics.timing_distribution.geckoview_startup_runtime.overflow, metrics.timing_distribution.geckoview_startup_runtime.range, metrics.timing_distribution.geckoview_startup_runtime.sum, metrics.timing_distribution.geckoview_startup_runtime.time_unit, metrics.timing_distribution.geckoview_startup_runtime.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.geckoview_startup_runtime.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_startup_runtime`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_compact_time.bucket_count, metrics.timing_distribution.javascript_gc_compact_time.count, metrics.timing_distribution.javascript_gc_compact_time.histogram_type, metrics.timing_distribution.javascript_gc_compact_time.overflow, metrics.timing_distribution.javascript_gc_compact_time.range, metrics.timing_distribution.javascript_gc_compact_time.sum, metrics.timing_distribution.javascript_gc_compact_time.time_unit, metrics.timing_distribution.javascript_gc_compact_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_compact_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_compact_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_mark_roots_time.bucket_count, metrics.timing_distribution.javascript_gc_mark_roots_time.count, metrics.timing_distribution.javascript_gc_mark_roots_time.histogram_type, metrics.timing_distribution.javascript_gc_mark_roots_time.overflow, metrics.timing_distribution.javascript_gc_mark_roots_time.range, metrics.timing_distribution.javascript_gc_mark_roots_time.sum, metrics.timing_distribution.javascript_gc_mark_roots_time.time_unit, metrics.timing_distribution.javascript_gc_mark_roots_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_mark_roots_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_mark_roots_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_mark_time.bucket_count, metrics.timing_distribution.javascript_gc_mark_time.count, metrics.timing_distribution.javascript_gc_mark_time.histogram_type, metrics.timing_distribution.javascript_gc_mark_time.overflow, metrics.timing_distribution.javascript_gc_mark_time.range, metrics.timing_distribution.javascript_gc_mark_time.sum, metrics.timing_distribution.javascript_gc_mark_time.time_unit, metrics.timing_distribution.javascript_gc_mark_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_mark_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_mark_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_minor_time.bucket_count, metrics.timing_distribution.javascript_gc_minor_time.count, metrics.timing_distribution.javascript_gc_minor_time.histogram_type, metrics.timing_distribution.javascript_gc_minor_time.overflow, metrics.timing_distribution.javascript_gc_minor_time.range, metrics.timing_distribution.javascript_gc_minor_time.sum, metrics.timing_distribution.javascript_gc_minor_time.time_unit, metrics.timing_distribution.javascript_gc_minor_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_minor_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_minor_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_prepare_time.bucket_count, metrics.timing_distribution.javascript_gc_prepare_time.count, metrics.timing_distribution.javascript_gc_prepare_time.histogram_type, metrics.timing_distribution.javascript_gc_prepare_time.overflow, metrics.timing_distribution.javascript_gc_prepare_time.range, metrics.timing_distribution.javascript_gc_prepare_time.sum, metrics.timing_distribution.javascript_gc_prepare_time.time_unit, metrics.timing_distribution.javascript_gc_prepare_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_prepare_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_prepare_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_slice_time.bucket_count, metrics.timing_distribution.javascript_gc_slice_time.count, metrics.timing_distribution.javascript_gc_slice_time.histogram_type, metrics.timing_distribution.javascript_gc_slice_time.overflow, metrics.timing_distribution.javascript_gc_slice_time.range, metrics.timing_distribution.javascript_gc_slice_time.sum, metrics.timing_distribution.javascript_gc_slice_time.time_unit, metrics.timing_distribution.javascript_gc_slice_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_slice_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_slice_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_sweep_time.bucket_count, metrics.timing_distribution.javascript_gc_sweep_time.count, metrics.timing_distribution.javascript_gc_sweep_time.histogram_type, metrics.timing_distribution.javascript_gc_sweep_time.overflow, metrics.timing_distribution.javascript_gc_sweep_time.range, metrics.timing_distribution.javascript_gc_sweep_time.sum, metrics.timing_distribution.javascript_gc_sweep_time.time_unit, metrics.timing_distribution.javascript_gc_sweep_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_sweep_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_sweep_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.javascript_gc_total_time.bucket_count, metrics.timing_distribution.javascript_gc_total_time.count, metrics.timing_distribution.javascript_gc_total_time.histogram_type, metrics.timing_distribution.javascript_gc_total_time.overflow, metrics.timing_distribution.javascript_gc_total_time.range, metrics.timing_distribution.javascript_gc_total_time.sum, metrics.timing_distribution.javascript_gc_total_time.time_unit, metrics.timing_distribution.javascript_gc_total_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.javascript_gc_total_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `javascript_gc_total_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_clone_deserialize_time.bucket_count, metrics.timing_distribution.performance_clone_deserialize_time.count, metrics.timing_distribution.performance_clone_deserialize_time.histogram_type, metrics.timing_distribution.performance_clone_deserialize_time.overflow, metrics.timing_distribution.performance_clone_deserialize_time.range, metrics.timing_distribution.performance_clone_deserialize_time.sum, metrics.timing_distribution.performance_clone_deserialize_time.time_unit, metrics.timing_distribution.performance_clone_deserialize_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_clone_deserialize_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_clone_deserialize_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_page_total_content_page_load.bucket_count, metrics.timing_distribution.performance_page_total_content_page_load.count, metrics.timing_distribution.performance_page_total_content_page_load.histogram_type, metrics.timing_distribution.performance_page_total_content_page_load.overflow, metrics.timing_distribution.performance_page_total_content_page_load.range, metrics.timing_distribution.performance_page_total_content_page_load.sum, metrics.timing_distribution.performance_page_total_content_page_load.time_unit, metrics.timing_distribution.performance_page_total_content_page_load.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_page_total_content_page_load.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_page_total_content_page_load`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_req_anim_frame_callback.bucket_count, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.count, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.histogram_type, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.overflow, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.range, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.sum, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.time_unit, metrics.timing_distribution.performance_pageload_req_anim_frame_callback.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_req_anim_frame_callback.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_req_anim_frame_callback`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.bucket_count, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.count, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.histogram_type, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.overflow, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.range, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.sum, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.time_unit, metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_responsiveness_req_anim_frame_callback.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_responsiveness_req_anim_frame_callback`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_time_response_start.bucket_count, metrics.timing_distribution.performance_time_response_start.count, metrics.timing_distribution.performance_time_response_start.histogram_type, metrics.timing_distribution.performance_time_response_start.overflow, metrics.timing_distribution.performance_time_response_start.range, metrics.timing_distribution.performance_time_response_start.sum, metrics.timing_distribution.performance_time_response_start.time_unit, metrics.timing_distribution.performance_time_response_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_time_response_start.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_time_response_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.httpsfirst_downgrade_time.bucket_count, metrics.timing_distribution.httpsfirst_downgrade_time.count, metrics.timing_distribution.httpsfirst_downgrade_time.histogram_type, metrics.timing_distribution.httpsfirst_downgrade_time.overflow, metrics.timing_distribution.httpsfirst_downgrade_time.range, metrics.timing_distribution.httpsfirst_downgrade_time.sum, metrics.timing_distribution.httpsfirst_downgrade_time.time_unit, metrics.timing_distribution.httpsfirst_downgrade_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.httpsfirst_downgrade_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `httpsfirst_downgrade_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.bucket_count, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.count, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.histogram_type, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.overflow, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.range, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.sum, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.time_unit, metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.httpsfirst_downgrade_time_schemeless.values) AS `values`
                                ) AS `values`
                            
                                ) AS `httpsfirst_downgrade_time_schemeless`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.bucket_count, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.count, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.histogram_type, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.overflow, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.range, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.sum, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.time_unit, metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_cssloader_ondatafinished_to_onstop_delay.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_cssloader_ondatafinished_to_onstop_delay`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.bucket_count, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.count, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.histogram_type, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.overflow, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.range, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.sum, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.time_unit, metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.cert_verifier_cert_trust_evaluation_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_verifier_cert_trust_evaluation_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_dns_native_https_call_time.bucket_count, metrics.timing_distribution.networking_dns_native_https_call_time.count, metrics.timing_distribution.networking_dns_native_https_call_time.histogram_type, metrics.timing_distribution.networking_dns_native_https_call_time.overflow, metrics.timing_distribution.networking_dns_native_https_call_time.range, metrics.timing_distribution.networking_dns_native_https_call_time.sum, metrics.timing_distribution.networking_dns_native_https_call_time.time_unit, metrics.timing_distribution.networking_dns_native_https_call_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_dns_native_https_call_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_dns_native_https_call_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.relevancy_classify_duration.bucket_count, metrics.timing_distribution.relevancy_classify_duration.count, metrics.timing_distribution.relevancy_classify_duration.histogram_type, metrics.timing_distribution.relevancy_classify_duration.overflow, metrics.timing_distribution.relevancy_classify_duration.range, metrics.timing_distribution.relevancy_classify_duration.sum, metrics.timing_distribution.relevancy_classify_duration.time_unit, metrics.timing_distribution.relevancy_classify_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.relevancy_classify_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `relevancy_classify_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.bounce_tracking_protection_purge_duration.bucket_count, metrics.timing_distribution.bounce_tracking_protection_purge_duration.count, metrics.timing_distribution.bounce_tracking_protection_purge_duration.histogram_type, metrics.timing_distribution.bounce_tracking_protection_purge_duration.overflow, metrics.timing_distribution.bounce_tracking_protection_purge_duration.range, metrics.timing_distribution.bounce_tracking_protection_purge_duration.sum, metrics.timing_distribution.bounce_tracking_protection_purge_duration.time_unit, metrics.timing_distribution.bounce_tracking_protection_purge_duration.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.bounce_tracking_protection_purge_duration.values) AS `values`
                                ) AS `values`
                            
                                ) AS `bounce_tracking_protection_purge_duration`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_async_sheet_load.bucket_count, metrics.timing_distribution.performance_pageload_async_sheet_load.count, metrics.timing_distribution.performance_pageload_async_sheet_load.histogram_type, metrics.timing_distribution.performance_pageload_async_sheet_load.overflow, metrics.timing_distribution.performance_pageload_async_sheet_load.range, metrics.timing_distribution.performance_pageload_async_sheet_load.sum, metrics.timing_distribution.performance_pageload_async_sheet_load.time_unit, metrics.timing_distribution.performance_pageload_async_sheet_load.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_async_sheet_load.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_async_sheet_load`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_onstart_suspend_total_time.bucket_count, metrics.timing_distribution.networking_http_onstart_suspend_total_time.count, metrics.timing_distribution.networking_http_onstart_suspend_total_time.histogram_type, metrics.timing_distribution.networking_http_onstart_suspend_total_time.overflow, metrics.timing_distribution.networking_http_onstart_suspend_total_time.range, metrics.timing_distribution.networking_http_onstart_suspend_total_time.sum, metrics.timing_distribution.networking_http_onstart_suspend_total_time.time_unit, metrics.timing_distribution.networking_http_onstart_suspend_total_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_onstart_suspend_total_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_onstart_suspend_total_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.bucket_count, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.count, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.histogram_type, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.overflow, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.range, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.sum, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.time_unit, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_eh_fcp_preconnect.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_eh_fcp_preconnect`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.bucket_count, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.count, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.histogram_type, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.overflow, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.range, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.sum, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.time_unit, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_with_eh.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_eh_fcp_preconnect_preload_with_eh`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.bucket_count, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.count, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.histogram_type, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.overflow, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.range, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.sum, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.time_unit, metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_eh_fcp_preconnect_preload_without_eh.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_eh_fcp_preconnect_preload_without_eh`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.bucket_count, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.count, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.histogram_type, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.overflow, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.range, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.sum, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.time_unit, metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_eh_fcp_preload_with_eh.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_eh_fcp_preload_with_eh`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.bucket_count, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.count, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.histogram_type, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.overflow, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.range, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.sum, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.time_unit, metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_eh_fcp_preload_without_eh.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_eh_fcp_preload_without_eh`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.bucket_count, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.count, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.histogram_type, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.overflow, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.range, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.sum, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.time_unit, metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_h3p_fcp_with_priority.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_h3p_fcp_with_priority`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_http3_fcp_http3.bucket_count, metrics.timing_distribution.performance_pageload_http3_fcp_http3.count, metrics.timing_distribution.performance_pageload_http3_fcp_http3.histogram_type, metrics.timing_distribution.performance_pageload_http3_fcp_http3.overflow, metrics.timing_distribution.performance_pageload_http3_fcp_http3.range, metrics.timing_distribution.performance_pageload_http3_fcp_http3.sum, metrics.timing_distribution.performance_pageload_http3_fcp_http3.time_unit, metrics.timing_distribution.performance_pageload_http3_fcp_http3.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_http3_fcp_http3.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_http3_fcp_http3`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.bucket_count, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.count, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.histogram_type, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.overflow, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.range, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.sum, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.time_unit, metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_http3_fcp_supports_http3.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_http3_fcp_supports_http3`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.bucket_count, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.count, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.histogram_type, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.overflow, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.range, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.sum, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.time_unit, metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.performance_pageload_http3_fcp_without_priority.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_pageload_http3_fcp_without_priority`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.glean_database_write_time.bucket_count, metrics.timing_distribution.glean_database_write_time.count, metrics.timing_distribution.glean_database_write_time.histogram_type, metrics.timing_distribution.glean_database_write_time.overflow, metrics.timing_distribution.glean_database_write_time.range, metrics.timing_distribution.glean_database_write_time.sum, metrics.timing_distribution.glean_database_write_time.time_unit, metrics.timing_distribution.glean_database_write_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.glean_database_write_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `glean_database_write_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.browser_backup_favicons_time.bucket_count, metrics.timing_distribution.browser_backup_favicons_time.count, metrics.timing_distribution.browser_backup_favicons_time.histogram_type, metrics.timing_distribution.browser_backup_favicons_time.overflow, metrics.timing_distribution.browser_backup_favicons_time.range, metrics.timing_distribution.browser_backup_favicons_time.sum, metrics.timing_distribution.browser_backup_favicons_time.time_unit, metrics.timing_distribution.browser_backup_favicons_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.browser_backup_favicons_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `browser_backup_favicons_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.browser_backup_places_time.bucket_count, metrics.timing_distribution.browser_backup_places_time.count, metrics.timing_distribution.browser_backup_places_time.histogram_type, metrics.timing_distribution.browser_backup_places_time.overflow, metrics.timing_distribution.browser_backup_places_time.range, metrics.timing_distribution.browser_backup_places_time.sum, metrics.timing_distribution.browser_backup_places_time.time_unit, metrics.timing_distribution.browser_backup_places_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.browser_backup_places_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `browser_backup_places_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.browser_backup_total_backup_time.bucket_count, metrics.timing_distribution.browser_backup_total_backup_time.count, metrics.timing_distribution.browser_backup_total_backup_time.histogram_type, metrics.timing_distribution.browser_backup_total_backup_time.overflow, metrics.timing_distribution.browser_backup_total_backup_time.range, metrics.timing_distribution.browser_backup_total_backup_time.sum, metrics.timing_distribution.browser_backup_total_backup_time.time_unit, metrics.timing_distribution.browser_backup_total_backup_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.browser_backup_total_backup_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `browser_backup_total_backup_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.urlbar_quick_suggest_ingest_time.bucket_count, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.count, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.histogram_type, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.overflow, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.range, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.sum, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.time_unit, metrics.timing_distribution.urlbar_quick_suggest_ingest_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.urlbar_quick_suggest_ingest_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `urlbar_quick_suggest_ingest_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_cache_metadata_first_read_time.bucket_count, metrics.timing_distribution.networking_cache_metadata_first_read_time.count, metrics.timing_distribution.networking_cache_metadata_first_read_time.histogram_type, metrics.timing_distribution.networking_cache_metadata_first_read_time.overflow, metrics.timing_distribution.networking_cache_metadata_first_read_time.range, metrics.timing_distribution.networking_cache_metadata_first_read_time.sum, metrics.timing_distribution.networking_cache_metadata_first_read_time.time_unit, metrics.timing_distribution.networking_cache_metadata_first_read_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_cache_metadata_first_read_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cache_metadata_first_read_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_cache_metadata_second_read_time.bucket_count, metrics.timing_distribution.networking_cache_metadata_second_read_time.count, metrics.timing_distribution.networking_cache_metadata_second_read_time.histogram_type, metrics.timing_distribution.networking_cache_metadata_second_read_time.overflow, metrics.timing_distribution.networking_cache_metadata_second_read_time.range, metrics.timing_distribution.networking_cache_metadata_second_read_time.sum, metrics.timing_distribution.networking_cache_metadata_second_read_time.time_unit, metrics.timing_distribution.networking_cache_metadata_second_read_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_cache_metadata_second_read_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cache_metadata_second_read_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.cert_verification_time_failure.bucket_count, metrics.timing_distribution.cert_verification_time_failure.count, metrics.timing_distribution.cert_verification_time_failure.histogram_type, metrics.timing_distribution.cert_verification_time_failure.overflow, metrics.timing_distribution.cert_verification_time_failure.range, metrics.timing_distribution.cert_verification_time_failure.sum, metrics.timing_distribution.cert_verification_time_failure.time_unit, metrics.timing_distribution.cert_verification_time_failure.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.cert_verification_time_failure.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_verification_time_failure`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.cert_verification_time_success.bucket_count, metrics.timing_distribution.cert_verification_time_success.count, metrics.timing_distribution.cert_verification_time_success.histogram_type, metrics.timing_distribution.cert_verification_time_success.overflow, metrics.timing_distribution.cert_verification_time_success.range, metrics.timing_distribution.cert_verification_time_success.sum, metrics.timing_distribution.cert_verification_time_success.time_unit, metrics.timing_distribution.cert_verification_time_success.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.cert_verification_time_success.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_verification_time_success`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.ocsp_request_time_cancel.bucket_count, metrics.timing_distribution.ocsp_request_time_cancel.count, metrics.timing_distribution.ocsp_request_time_cancel.histogram_type, metrics.timing_distribution.ocsp_request_time_cancel.overflow, metrics.timing_distribution.ocsp_request_time_cancel.range, metrics.timing_distribution.ocsp_request_time_cancel.sum, metrics.timing_distribution.ocsp_request_time_cancel.time_unit, metrics.timing_distribution.ocsp_request_time_cancel.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.ocsp_request_time_cancel.values) AS `values`
                                ) AS `values`
                            
                                ) AS `ocsp_request_time_cancel`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.ocsp_request_time_failure.bucket_count, metrics.timing_distribution.ocsp_request_time_failure.count, metrics.timing_distribution.ocsp_request_time_failure.histogram_type, metrics.timing_distribution.ocsp_request_time_failure.overflow, metrics.timing_distribution.ocsp_request_time_failure.range, metrics.timing_distribution.ocsp_request_time_failure.sum, metrics.timing_distribution.ocsp_request_time_failure.time_unit, metrics.timing_distribution.ocsp_request_time_failure.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.ocsp_request_time_failure.values) AS `values`
                                ) AS `values`
                            
                                ) AS `ocsp_request_time_failure`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.ocsp_request_time_success.bucket_count, metrics.timing_distribution.ocsp_request_time_success.count, metrics.timing_distribution.ocsp_request_time_success.histogram_type, metrics.timing_distribution.ocsp_request_time_success.overflow, metrics.timing_distribution.ocsp_request_time_success.range, metrics.timing_distribution.ocsp_request_time_success.sum, metrics.timing_distribution.ocsp_request_time_success.time_unit, metrics.timing_distribution.ocsp_request_time_success.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.ocsp_request_time_success.values) AS `values`
                                ) AS `values`
                            
                                ) AS `ocsp_request_time_success`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.bucket_count, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.count, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.histogram_type, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.overflow, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.range, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.sum, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.time_unit, metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_http_content_ondatafinished_delay_2.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_content_ondatafinished_delay_2`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.ls_preparedatastore_processing_time.bucket_count, metrics.timing_distribution.ls_preparedatastore_processing_time.count, metrics.timing_distribution.ls_preparedatastore_processing_time.histogram_type, metrics.timing_distribution.ls_preparedatastore_processing_time.overflow, metrics.timing_distribution.ls_preparedatastore_processing_time.range, metrics.timing_distribution.ls_preparedatastore_processing_time.sum, metrics.timing_distribution.ls_preparedatastore_processing_time.time_unit, metrics.timing_distribution.ls_preparedatastore_processing_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.ls_preparedatastore_processing_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `ls_preparedatastore_processing_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.ls_preparelsdatabase_processing_time.bucket_count, metrics.timing_distribution.ls_preparelsdatabase_processing_time.count, metrics.timing_distribution.ls_preparelsdatabase_processing_time.histogram_type, metrics.timing_distribution.ls_preparelsdatabase_processing_time.overflow, metrics.timing_distribution.ls_preparelsdatabase_processing_time.range, metrics.timing_distribution.ls_preparelsdatabase_processing_time.sum, metrics.timing_distribution.ls_preparelsdatabase_processing_time.time_unit, metrics.timing_distribution.ls_preparelsdatabase_processing_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.ls_preparelsdatabase_processing_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `ls_preparelsdatabase_processing_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.bucket_count, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.count, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.histogram_type, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.overflow, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.range, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.sum, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.time_unit, metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_sqlite_cookies_block_main_thread.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_sqlite_cookies_block_main_thread`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.bucket_count, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.count, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.histogram_type, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.overflow, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.range, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.sum, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.time_unit, metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.networking_sqlite_cookies_time_to_block_main_thread.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_sqlite_cookies_time_to_block_main_thread`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_cache_read_time.bucket_count, metrics.timing_distribution.network_cache_read_time.count, metrics.timing_distribution.network_cache_read_time.histogram_type, metrics.timing_distribution.network_cache_read_time.overflow, metrics.timing_distribution.network_cache_read_time.range, metrics.timing_distribution.network_cache_read_time.sum, metrics.timing_distribution.network_cache_read_time.time_unit, metrics.timing_distribution.network_cache_read_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_cache_read_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_cache_read_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_complete_load.bucket_count, metrics.timing_distribution.network_complete_load.count, metrics.timing_distribution.network_complete_load.histogram_type, metrics.timing_distribution.network_complete_load.overflow, metrics.timing_distribution.network_complete_load.range, metrics.timing_distribution.network_complete_load.sum, metrics.timing_distribution.network_complete_load.time_unit, metrics.timing_distribution.network_complete_load.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_complete_load.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_complete_load`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_complete_load_cached.bucket_count, metrics.timing_distribution.network_complete_load_cached.count, metrics.timing_distribution.network_complete_load_cached.histogram_type, metrics.timing_distribution.network_complete_load_cached.overflow, metrics.timing_distribution.network_complete_load_cached.range, metrics.timing_distribution.network_complete_load_cached.sum, metrics.timing_distribution.network_complete_load_cached.time_unit, metrics.timing_distribution.network_complete_load_cached.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_complete_load_cached.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_complete_load_cached`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_complete_load_net.bucket_count, metrics.timing_distribution.network_complete_load_net.count, metrics.timing_distribution.network_complete_load_net.histogram_type, metrics.timing_distribution.network_complete_load_net.overflow, metrics.timing_distribution.network_complete_load_net.range, metrics.timing_distribution.network_complete_load_net.sum, metrics.timing_distribution.network_complete_load_net.time_unit, metrics.timing_distribution.network_complete_load_net.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_complete_load_net.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_complete_load_net`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_first_sent_to_last_received.bucket_count, metrics.timing_distribution.network_first_sent_to_last_received.count, metrics.timing_distribution.network_first_sent_to_last_received.histogram_type, metrics.timing_distribution.network_first_sent_to_last_received.overflow, metrics.timing_distribution.network_first_sent_to_last_received.range, metrics.timing_distribution.network_first_sent_to_last_received.sum, metrics.timing_distribution.network_first_sent_to_last_received.time_unit, metrics.timing_distribution.network_first_sent_to_last_received.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_first_sent_to_last_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_first_sent_to_last_received`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_http_revalidation.bucket_count, metrics.timing_distribution.network_http_revalidation.count, metrics.timing_distribution.network_http_revalidation.histogram_type, metrics.timing_distribution.network_http_revalidation.overflow, metrics.timing_distribution.network_http_revalidation.range, metrics.timing_distribution.network_http_revalidation.sum, metrics.timing_distribution.network_http_revalidation.time_unit, metrics.timing_distribution.network_http_revalidation.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_http_revalidation.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_http_revalidation`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_open_to_first_received.bucket_count, metrics.timing_distribution.network_open_to_first_received.count, metrics.timing_distribution.network_open_to_first_received.histogram_type, metrics.timing_distribution.network_open_to_first_received.overflow, metrics.timing_distribution.network_open_to_first_received.range, metrics.timing_distribution.network_open_to_first_received.sum, metrics.timing_distribution.network_open_to_first_received.time_unit, metrics.timing_distribution.network_open_to_first_received.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_open_to_first_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_open_to_first_received`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_open_to_first_sent.bucket_count, metrics.timing_distribution.network_open_to_first_sent.count, metrics.timing_distribution.network_open_to_first_sent.histogram_type, metrics.timing_distribution.network_open_to_first_sent.overflow, metrics.timing_distribution.network_open_to_first_sent.range, metrics.timing_distribution.network_open_to_first_sent.sum, metrics.timing_distribution.network_open_to_first_sent.time_unit, metrics.timing_distribution.network_open_to_first_sent.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_open_to_first_sent.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_open_to_first_sent`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_cache_read_time.bucket_count, metrics.timing_distribution.network_sub_cache_read_time.count, metrics.timing_distribution.network_sub_cache_read_time.histogram_type, metrics.timing_distribution.network_sub_cache_read_time.overflow, metrics.timing_distribution.network_sub_cache_read_time.range, metrics.timing_distribution.network_sub_cache_read_time.sum, metrics.timing_distribution.network_sub_cache_read_time.time_unit, metrics.timing_distribution.network_sub_cache_read_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_cache_read_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_cache_read_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_complete_load.bucket_count, metrics.timing_distribution.network_sub_complete_load.count, metrics.timing_distribution.network_sub_complete_load.histogram_type, metrics.timing_distribution.network_sub_complete_load.overflow, metrics.timing_distribution.network_sub_complete_load.range, metrics.timing_distribution.network_sub_complete_load.sum, metrics.timing_distribution.network_sub_complete_load.time_unit, metrics.timing_distribution.network_sub_complete_load.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_complete_load.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_complete_load`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_complete_load_cached.bucket_count, metrics.timing_distribution.network_sub_complete_load_cached.count, metrics.timing_distribution.network_sub_complete_load_cached.histogram_type, metrics.timing_distribution.network_sub_complete_load_cached.overflow, metrics.timing_distribution.network_sub_complete_load_cached.range, metrics.timing_distribution.network_sub_complete_load_cached.sum, metrics.timing_distribution.network_sub_complete_load_cached.time_unit, metrics.timing_distribution.network_sub_complete_load_cached.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_complete_load_cached.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_complete_load_cached`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_complete_load_net.bucket_count, metrics.timing_distribution.network_sub_complete_load_net.count, metrics.timing_distribution.network_sub_complete_load_net.histogram_type, metrics.timing_distribution.network_sub_complete_load_net.overflow, metrics.timing_distribution.network_sub_complete_load_net.range, metrics.timing_distribution.network_sub_complete_load_net.sum, metrics.timing_distribution.network_sub_complete_load_net.time_unit, metrics.timing_distribution.network_sub_complete_load_net.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_complete_load_net.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_complete_load_net`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_dns_end.bucket_count, metrics.timing_distribution.network_sub_dns_end.count, metrics.timing_distribution.network_sub_dns_end.histogram_type, metrics.timing_distribution.network_sub_dns_end.overflow, metrics.timing_distribution.network_sub_dns_end.range, metrics.timing_distribution.network_sub_dns_end.sum, metrics.timing_distribution.network_sub_dns_end.time_unit, metrics.timing_distribution.network_sub_dns_end.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_dns_end.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_dns_end`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_dns_start.bucket_count, metrics.timing_distribution.network_sub_dns_start.count, metrics.timing_distribution.network_sub_dns_start.histogram_type, metrics.timing_distribution.network_sub_dns_start.overflow, metrics.timing_distribution.network_sub_dns_start.range, metrics.timing_distribution.network_sub_dns_start.sum, metrics.timing_distribution.network_sub_dns_start.time_unit, metrics.timing_distribution.network_sub_dns_start.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_dns_start.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_dns_start`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_first_from_cache.bucket_count, metrics.timing_distribution.network_sub_first_from_cache.count, metrics.timing_distribution.network_sub_first_from_cache.histogram_type, metrics.timing_distribution.network_sub_first_from_cache.overflow, metrics.timing_distribution.network_sub_first_from_cache.range, metrics.timing_distribution.network_sub_first_from_cache.sum, metrics.timing_distribution.network_sub_first_from_cache.time_unit, metrics.timing_distribution.network_sub_first_from_cache.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_first_from_cache.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_first_from_cache`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_first_sent_to_last_received.bucket_count, metrics.timing_distribution.network_sub_first_sent_to_last_received.count, metrics.timing_distribution.network_sub_first_sent_to_last_received.histogram_type, metrics.timing_distribution.network_sub_first_sent_to_last_received.overflow, metrics.timing_distribution.network_sub_first_sent_to_last_received.range, metrics.timing_distribution.network_sub_first_sent_to_last_received.sum, metrics.timing_distribution.network_sub_first_sent_to_last_received.time_unit, metrics.timing_distribution.network_sub_first_sent_to_last_received.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_first_sent_to_last_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_first_sent_to_last_received`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_http_revalidation.bucket_count, metrics.timing_distribution.network_sub_http_revalidation.count, metrics.timing_distribution.network_sub_http_revalidation.histogram_type, metrics.timing_distribution.network_sub_http_revalidation.overflow, metrics.timing_distribution.network_sub_http_revalidation.range, metrics.timing_distribution.network_sub_http_revalidation.sum, metrics.timing_distribution.network_sub_http_revalidation.time_unit, metrics.timing_distribution.network_sub_http_revalidation.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_http_revalidation.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_http_revalidation`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_open_to_first_received.bucket_count, metrics.timing_distribution.network_sub_open_to_first_received.count, metrics.timing_distribution.network_sub_open_to_first_received.histogram_type, metrics.timing_distribution.network_sub_open_to_first_received.overflow, metrics.timing_distribution.network_sub_open_to_first_received.range, metrics.timing_distribution.network_sub_open_to_first_received.sum, metrics.timing_distribution.network_sub_open_to_first_received.time_unit, metrics.timing_distribution.network_sub_open_to_first_received.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_open_to_first_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_open_to_first_received`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_open_to_first_sent.bucket_count, metrics.timing_distribution.network_sub_open_to_first_sent.count, metrics.timing_distribution.network_sub_open_to_first_sent.histogram_type, metrics.timing_distribution.network_sub_open_to_first_sent.overflow, metrics.timing_distribution.network_sub_open_to_first_sent.range, metrics.timing_distribution.network_sub_open_to_first_sent.sum, metrics.timing_distribution.network_sub_open_to_first_sent.time_unit, metrics.timing_distribution.network_sub_open_to_first_sent.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_open_to_first_sent.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_open_to_first_sent`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_tcp_connection.bucket_count, metrics.timing_distribution.network_sub_tcp_connection.count, metrics.timing_distribution.network_sub_tcp_connection.histogram_type, metrics.timing_distribution.network_sub_tcp_connection.overflow, metrics.timing_distribution.network_sub_tcp_connection.range, metrics.timing_distribution.network_sub_tcp_connection.sum, metrics.timing_distribution.network_sub_tcp_connection.time_unit, metrics.timing_distribution.network_sub_tcp_connection.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_tcp_connection.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_tcp_connection`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_sub_tls_handshake.bucket_count, metrics.timing_distribution.network_sub_tls_handshake.count, metrics.timing_distribution.network_sub_tls_handshake.histogram_type, metrics.timing_distribution.network_sub_tls_handshake.overflow, metrics.timing_distribution.network_sub_tls_handshake.range, metrics.timing_distribution.network_sub_tls_handshake.sum, metrics.timing_distribution.network_sub_tls_handshake.time_unit, metrics.timing_distribution.network_sub_tls_handshake.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_sub_tls_handshake.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_sub_tls_handshake`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.bucket_count, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.count, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.histogram_type, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.overflow, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.range, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.sum, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.time_unit, metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.localstorage_database_request_allow_to_close_response_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `localstorage_database_request_allow_to_close_response_time`
                            , 
                                STRUCT(
                                    metrics.timing_distribution.network_cache_miss_time.bucket_count, metrics.timing_distribution.network_cache_miss_time.count, metrics.timing_distribution.network_cache_miss_time.histogram_type, metrics.timing_distribution.network_cache_miss_time.overflow, metrics.timing_distribution.network_cache_miss_time.range, metrics.timing_distribution.network_cache_miss_time.sum, metrics.timing_distribution.network_cache_miss_time.time_unit, metrics.timing_distribution.network_cache_miss_time.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.timing_distribution.network_cache_miss_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_cache_miss_time`
                            
                                ) AS `timing_distribution`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            labeled_rate.key, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            value.key, 
                                STRUCT(
                                    value.value.denominator, value.value.numerator
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(labeled_rate.value) AS `value`
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_rate) AS `labeled_rate`
                                ) AS `labeled_rate`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            url.key, url.value
                                        )
                                    FROM UNNEST(metrics.url) AS `url`
                                ) AS `url`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            text.key, text.value
                                        )
                                    FROM UNNEST(metrics.text) AS `text`
                                ) AS `text`
                            , 
                                STRUCT(
                                    metrics.quantity.browser_link_open_newwindow_restriction, metrics.quantity.browser_engagement_profile_count, metrics.quantity.extensions_apis_dnr_evaluate_rules_count_max, metrics.quantity.extensions_quarantined_domains_listsize, metrics.quantity.formautofill_creditcards_autofill_profiles_count, metrics.quantity.fog_max_pings_per_minute, metrics.quantity.fog_validation_gvsv_primary_height, metrics.quantity.fog_validation_gvsv_primary_width, metrics.quantity.extensions_startup_cache_write_bytelength, metrics.quantity.gpu_process_total_launch_attempts, metrics.quantity.gpu_process_unstable_launch_attempts, metrics.quantity.data_storage_alternate_services, metrics.quantity.data_storage_client_auth_remember_list, metrics.quantity.data_storage_site_security_service_state, metrics.quantity.gfx_adapter_primary_ram, metrics.quantity.gfx_display_count, metrics.quantity.gfx_display_primary_height, metrics.quantity.gfx_display_primary_width, metrics.quantity.browser_backup_prof_d_disk_space, metrics.quantity.browser_backup_favicons_size, metrics.quantity.browser_backup_places_size, metrics.quantity.browser_backup_credentials_data_size, metrics.quantity.browser_backup_security_data_size, metrics.quantity.browser_backup_cookies_size, metrics.quantity.browser_backup_form_history_size, metrics.quantity.browser_backup_misc_data_size, metrics.quantity.browser_backup_preferences_size, metrics.quantity.browser_backup_session_store_backups_directory_size, metrics.quantity.browser_backup_session_store_size, metrics.quantity.browser_backup_browser_extension_data_size, metrics.quantity.browser_backup_extension_store_permissions_data_size, metrics.quantity.browser_backup_extensions_json_size, metrics.quantity.browser_backup_extensions_storage_size, metrics.quantity.browser_backup_extensions_xpi_directory_size, metrics.quantity.browser_backup_storage_sync_size, metrics.quantity.cert_verifier_trust_obj_count, metrics.quantity.pkcs11_third_party_modules_loaded, metrics.quantity.sidebar_width, metrics.quantity.a11y_hcm_background, metrics.quantity.a11y_hcm_foreground, metrics.quantity.browser_startup_abouthome_cache_result, metrics.quantity.datasanitization_session_permission_exceptions, metrics.quantity.gfx_hdr_windows_display_colorspace_bitfield, metrics.quantity.networking_doh_heuristics_result, metrics.quantity.networking_https_rr_prefs_usage, metrics.quantity.pwmgr_potentially_breached_passwords, metrics.quantity.pictureinpicture_most_concurrent_players, metrics.quantity.places_pages_need_frecency_recalculation, metrics.quantity.places_previousday_visits, metrics.quantity.startup_seconds_since_last_os_restart, metrics.quantity.contentblocking_category, metrics.quantity.policies_count, metrics.quantity.startup_profile_count, metrics.quantity.security_global_privacy_control_enabled, metrics.quantity.security_https_only_mode_enabled, metrics.quantity.security_https_only_mode_enabled_pbm, metrics.quantity.browser_engagement_max_concurrent_tab_count, metrics.quantity.browser_engagement_max_concurrent_tab_pinned_count, metrics.quantity.browser_engagement_max_concurrent_vertical_tab_count, metrics.quantity.browser_engagement_max_concurrent_vertical_tab_pinned_count, metrics.quantity.browser_engagement_max_concurrent_window_count, metrics.quantity.networking_loading_certs_task, metrics.quantity.networking_nss_initialization, metrics.quantity.bounce_tracking_protection_mode, metrics.quantity.browser_engagement_session_time_excluding_suspend, metrics.quantity.browser_engagement_session_time_including_suspend, metrics.quantity.browser_engagement_unique_domains_count, metrics.quantity.browser_backup_location_on_device
                                ) AS `quantity`
                            , 
                                STRUCT(
                                    
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            startup_run_from_dmg_install_outcome.key, startup_run_from_dmg_install_outcome.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.startup_run_from_dmg_install_outcome) AS `startup_run_from_dmg_install_outcome`
                                ) AS `startup_run_from_dmg_install_outcome`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_normal_window_service_mode.key, cookie_banners_normal_window_service_mode.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.cookie_banners_normal_window_service_mode) AS `cookie_banners_normal_window_service_mode`
                                ) AS `cookie_banners_normal_window_service_mode`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_private_window_service_mode.key, cookie_banners_private_window_service_mode.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.cookie_banners_private_window_service_mode) AS `cookie_banners_private_window_service_mode`
                                ) AS `cookie_banners_private_window_service_mode`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            data_storage_migration.key, data_storage_migration.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.data_storage_migration) AS `data_storage_migration`
                                ) AS `data_storage_migration`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            oskeystore_self_test.key, oskeystore_self_test.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.oskeystore_self_test) AS `oskeystore_self_test`
                                ) AS `oskeystore_self_test`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_playback_device_hardware_decoder_support.key, media_playback_device_hardware_decoder_support.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.media_playback_device_hardware_decoder_support) AS `media_playback_device_hardware_decoder_support`
                                ) AS `media_playback_device_hardware_decoder_support`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            geolocation_linux_provider.key, geolocation_linux_provider.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.geolocation_linux_provider) AS `geolocation_linux_provider`
                                ) AS `geolocation_linux_provider`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            pdfjs_image_alt_text_edit.key, pdfjs_image_alt_text_edit.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.pdfjs_image_alt_text_edit) AS `pdfjs_image_alt_text_edit`
                                ) AS `pdfjs_image_alt_text_edit`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            a11y_theme.key, a11y_theme.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.a11y_theme) AS `a11y_theme`
                                ) AS `a11y_theme`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_video_hardware_decoding_support.key, media_video_hardware_decoding_support.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.media_video_hardware_decoding_support) AS `media_video_hardware_decoding_support`
                                ) AS `media_video_hardware_decoding_support`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            media_video_hd_hardware_decoding_support.key, media_video_hd_hardware_decoding_support.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.media_video_hd_hardware_decoding_support) AS `media_video_hd_hardware_decoding_support`
                                ) AS `media_video_hd_hardware_decoding_support`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_doh_heuristic_ever_tripped.key, networking_doh_heuristic_ever_tripped.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.networking_doh_heuristic_ever_tripped) AS `networking_doh_heuristic_ever_tripped`
                                ) AS `networking_doh_heuristic_ever_tripped`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            widget_ime_name_on_mac.key, widget_ime_name_on_mac.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.widget_ime_name_on_mac) AS `widget_ime_name_on_mac`
                                ) AS `widget_ime_name_on_mac`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            widget_ime_name_on_windows.key, widget_ime_name_on_windows.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.widget_ime_name_on_windows) AS `widget_ime_name_on_windows`
                                ) AS `widget_ime_name_on_windows`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            widget_ime_name_on_windows_inserted_crlf.key, widget_ime_name_on_windows_inserted_crlf.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.widget_ime_name_on_windows_inserted_crlf) AS `widget_ime_name_on_windows_inserted_crlf`
                                ) AS `widget_ime_name_on_windows_inserted_crlf`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            os_environment_is_default_handler.key, os_environment_is_default_handler.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.os_environment_is_default_handler) AS `os_environment_is_default_handler`
                                ) AS `os_environment_is_default_handler`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            widget_ime_name_on_linux.key, widget_ime_name_on_linux.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.widget_ime_name_on_linux) AS `widget_ime_name_on_linux`
                                ) AS `widget_ime_name_on_linux`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            browser_ui_mirror_for_toolbar_widgets.key, browser_ui_mirror_for_toolbar_widgets.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.browser_ui_mirror_for_toolbar_widgets) AS `browser_ui_mirror_for_toolbar_widgets`
                                ) AS `browser_ui_mirror_for_toolbar_widgets`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            widget_pointing_devices.key, widget_pointing_devices.value
                                        )
                                    FROM UNNEST(metrics.labeled_boolean.widget_pointing_devices) AS `widget_pointing_devices`
                                ) AS `widget_pointing_devices`
                            , CAST(NULL AS ARRAY<STRUCT<`key` STRING, `value` BOOLEAN>>) AS `mediadrm_decryption`
                                ) AS `labeled_boolean`
                            , 
                                STRUCT(
                                    metrics.uuid.legacy_telemetry_client_id, metrics.uuid.legacy_telemetry_profile_group_id
                                ) AS `uuid`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metrics.custom_distribution.power_battery_percentage_when_user_active.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.power_battery_percentage_when_user_active.values) AS `values`
                                ) AS `values`
                            , metrics.custom_distribution.power_battery_percentage_when_user_active.count
                                ) AS `power_battery_percentage_when_user_active`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.pdfjs_time_to_view.count, metrics.custom_distribution.pdfjs_time_to_view.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.pdfjs_time_to_view.values) AS `values`
                                ) AS `values`
                            
                                ) AS `pdfjs_time_to_view`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.timer_thread_timers_fired_per_wakeup.count, metrics.custom_distribution.timer_thread_timers_fired_per_wakeup.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.timer_thread_timers_fired_per_wakeup.values) AS `values`
                                ) AS `values`
                            
                                ) AS `timer_thread_timers_fired_per_wakeup`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_access_fixup_diff.count, metrics.custom_distribution.networking_cookie_access_fixup_diff.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_access_fixup_diff.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_access_fixup_diff`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_creation_fixup_diff.count, metrics.custom_distribution.networking_cookie_creation_fixup_diff.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_creation_fixup_diff.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_creation_fixup_diff`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_1_download_throughput.count, metrics.custom_distribution.networking_http_1_download_throughput.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_1_download_throughput.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_1_download_throughput`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_2_download_throughput.count, metrics.custom_distribution.networking_http_2_download_throughput.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_2_download_throughput.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_2_download_throughput`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_download_throughput.count, metrics.custom_distribution.networking_http_3_download_throughput.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_download_throughput.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_download_throughput`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cookie_banners_click_query_selector_run_count_per_window_frame.count, metrics.custom_distribution.cookie_banners_click_query_selector_run_count_per_window_frame.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cookie_banners_click_query_selector_run_count_per_window_frame.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cookie_banners_click_query_selector_run_count_per_window_frame`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cookie_banners_click_query_selector_run_count_per_window_top_level.count, metrics.custom_distribution.cookie_banners_click_query_selector_run_count_per_window_top_level.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cookie_banners_click_query_selector_run_count_per_window_top_level.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cookie_banners_click_query_selector_run_count_per_window_top_level`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cookie_banners_click_query_selector_run_duration_per_window_frame.count, metrics.custom_distribution.cookie_banners_click_query_selector_run_duration_per_window_frame.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cookie_banners_click_query_selector_run_duration_per_window_frame.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cookie_banners_click_query_selector_run_duration_per_window_frame`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cookie_banners_click_query_selector_run_duration_per_window_top_level.count, metrics.custom_distribution.cookie_banners_click_query_selector_run_duration_per_window_top_level.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cookie_banners_click_query_selector_run_duration_per_window_top_level.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cookie_banners_click_query_selector_run_duration_per_window_top_level`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_1_upload_throughput.count, metrics.custom_distribution.networking_http_1_upload_throughput.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_1_upload_throughput.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_1_upload_throughput`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_2_upload_throughput.count, metrics.custom_distribution.networking_http_2_upload_throughput.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_2_upload_throughput.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_2_upload_throughput`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_upload_throughput.count, metrics.custom_distribution.networking_http_3_upload_throughput.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_upload_throughput.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_upload_throughput`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.fog_validation_gvsv_number_of_unique_site_origins_all_tabs.count, metrics.custom_distribution.fog_validation_gvsv_number_of_unique_site_origins_all_tabs.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.fog_validation_gvsv_number_of_unique_site_origins_all_tabs.values) AS `values`
                                ) AS `values`
                            
                                ) AS `fog_validation_gvsv_number_of_unique_site_origins_all_tabs`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.extensions_timing_event_page_running_time.count, metrics.custom_distribution.extensions_timing_event_page_running_time.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.extensions_timing_event_page_running_time.values) AS `values`
                                ) AS `values`
                            
                                ) AS `extensions_timing_event_page_running_time`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_count_part_by_key.count, metrics.custom_distribution.networking_cookie_count_part_by_key.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_count_part_by_key.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_count_part_by_key`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_count_partitioned.count, metrics.custom_distribution.networking_cookie_count_partitioned.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_count_partitioned.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_count_partitioned`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_count_total.count, metrics.custom_distribution.networking_cookie_count_total.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_count_total.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_count_total`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_count_unpart_by_key.count, metrics.custom_distribution.networking_cookie_count_unpart_by_key.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_count_unpart_by_key.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_count_unpart_by_key`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_count_unpartitioned.count, metrics.custom_distribution.networking_cookie_count_unpartitioned.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_count_unpartitioned.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_count_unpartitioned`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_purge_entry_max.count, metrics.custom_distribution.networking_cookie_purge_entry_max.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_purge_entry_max.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_purge_entry_max`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_purge_max.count, metrics.custom_distribution.networking_cookie_purge_max.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_purge_max.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_purge_max`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_1_upload_throughput_100.count, metrics.custom_distribution.networking_http_1_upload_throughput_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_1_upload_throughput_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_1_upload_throughput_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_1_upload_throughput_10_50.count, metrics.custom_distribution.networking_http_1_upload_throughput_10_50.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_1_upload_throughput_10_50.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_1_upload_throughput_10_50`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_1_upload_throughput_50_100.count, metrics.custom_distribution.networking_http_1_upload_throughput_50_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_1_upload_throughput_50_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_1_upload_throughput_50_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_2_upload_throughput_100.count, metrics.custom_distribution.networking_http_2_upload_throughput_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_2_upload_throughput_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_2_upload_throughput_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_2_upload_throughput_10_50.count, metrics.custom_distribution.networking_http_2_upload_throughput_10_50.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_2_upload_throughput_10_50.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_2_upload_throughput_10_50`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_2_upload_throughput_50_100.count, metrics.custom_distribution.networking_http_2_upload_throughput_50_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_2_upload_throughput_50_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_2_upload_throughput_50_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_upload_throughput_100.count, metrics.custom_distribution.networking_http_3_upload_throughput_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_upload_throughput_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_upload_throughput_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_upload_throughput_10_50.count, metrics.custom_distribution.networking_http_3_upload_throughput_10_50.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_upload_throughput_10_50.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_upload_throughput_10_50`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_upload_throughput_50_100.count, metrics.custom_distribution.networking_http_3_upload_throughput_50_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_upload_throughput_50_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_upload_throughput_50_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_checkerboard_peak_pixel_count.count, metrics.custom_distribution.gfx_checkerboard_peak_pixel_count.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_checkerboard_peak_pixel_count.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_checkerboard_peak_pixel_count`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_checkerboard_severity.count, metrics.custom_distribution.gfx_checkerboard_severity.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_checkerboard_severity.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_checkerboard_severity`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_content_frame_time_from_paint.count, metrics.custom_distribution.gfx_content_frame_time_from_paint.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_content_frame_time_from_paint.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_frame_time_from_paint`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_content_frame_time_from_vsync.count, metrics.custom_distribution.gfx_content_frame_time_from_vsync.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_content_frame_time_from_vsync.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_frame_time_from_vsync`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_content_frame_time_with_svg.count, metrics.custom_distribution.gfx_content_frame_time_with_svg.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_content_frame_time_with_svg.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_frame_time_with_svg`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_content_frame_time_without_resource_upload.count, metrics.custom_distribution.gfx_content_frame_time_without_resource_upload.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_content_frame_time_without_resource_upload.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_frame_time_without_resource_upload`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.gfx_content_frame_time_without_upload.count, metrics.custom_distribution.gfx_content_frame_time_without_upload.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.gfx_content_frame_time_without_upload.values) AS `values`
                                ) AS `values`
                            
                                ) AS `gfx_content_frame_time_without_upload`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.geckoview_document_site_origins.count, metrics.custom_distribution.geckoview_document_site_origins.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.geckoview_document_site_origins.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_document_site_origins`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.geckoview_per_document_site_origins.count, metrics.custom_distribution.geckoview_per_document_site_origins.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.geckoview_per_document_site_origins.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geckoview_per_document_site_origins`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.performance_clone_deserialize_items.count, metrics.custom_distribution.performance_clone_deserialize_items.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.performance_clone_deserialize_items.values) AS `values`
                                ) AS `values`
                            
                                ) AS `performance_clone_deserialize_items`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.pdfjs_editing_highlight_thickness.count, metrics.custom_distribution.pdfjs_editing_highlight_thickness.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.pdfjs_editing_highlight_thickness.values) AS `values`
                                ) AS `values`
                            
                                ) AS `pdfjs_editing_highlight_thickness`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.network_tls_early_data_bytes_written.count, metrics.custom_distribution.network_tls_early_data_bytes_written.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.network_tls_early_data_bytes_written.values) AS `values`
                                ) AS `values`
                            
                                ) AS `network_tls_early_data_bytes_written`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cert_compression_brotli_saved_bytes.count, metrics.custom_distribution.cert_compression_brotli_saved_bytes.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cert_compression_brotli_saved_bytes.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_compression_brotli_saved_bytes`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cert_compression_zlib_saved_bytes.count, metrics.custom_distribution.cert_compression_zlib_saved_bytes.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cert_compression_zlib_saved_bytes.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_compression_zlib_saved_bytes`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.bounce_tracking_protection_num_hosts_per_purge_run.count, metrics.custom_distribution.bounce_tracking_protection_num_hosts_per_purge_run.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.bounce_tracking_protection_num_hosts_per_purge_run.values) AS `values`
                                ) AS `values`
                            
                                ) AS `bounce_tracking_protection_num_hosts_per_purge_run`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.cert_compression_zstd_saved_bytes.count, metrics.custom_distribution.cert_compression_zstd_saved_bytes.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.cert_compression_zstd_saved_bytes.values) AS `values`
                                ) AS `values`
                            
                                ) AS `cert_compression_zstd_saved_bytes`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_cookie_chips_partition_limit_overflow.count, metrics.custom_distribution.networking_cookie_chips_partition_limit_overflow.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_cookie_chips_partition_limit_overflow.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_cookie_chips_partition_limit_overflow`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.geolocation_accuracy.count, metrics.custom_distribution.geolocation_accuracy.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.geolocation_accuracy.values) AS `values`
                                ) AS `values`
                            
                                ) AS `geolocation_accuracy`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_download_throughput_100.count, metrics.custom_distribution.networking_http_3_download_throughput_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_download_throughput_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_download_throughput_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_download_throughput_10_50.count, metrics.custom_distribution.networking_http_3_download_throughput_10_50.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_download_throughput_10_50.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_download_throughput_10_50`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_download_throughput_50_100.count, metrics.custom_distribution.networking_http_3_download_throughput_50_100.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_download_throughput_50_100.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_download_throughput_50_100`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_udp_datagram_segments_received.count, metrics.custom_distribution.networking_http_3_udp_datagram_segments_received.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_udp_datagram_segments_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_udp_datagram_segments_received`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_loss_ratio.count, metrics.custom_distribution.networking_http_3_loss_ratio.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_loss_ratio.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_loss_ratio`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_ecn_ce_ect0_ratio_received.count, metrics.custom_distribution.networking_http_3_ecn_ce_ect0_ratio_received.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_ecn_ce_ect0_ratio_received.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_ecn_ce_ect0_ratio_received`
                            , 
                                STRUCT(
                                    metrics.custom_distribution.networking_http_3_ecn_ce_ect0_ratio_sent.count, metrics.custom_distribution.networking_http_3_ecn_ce_ect0_ratio_sent.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(metrics.custom_distribution.networking_http_3_ecn_ce_ect0_ratio_sent.values) AS `values`
                                ) AS `values`
                            
                                ) AS `networking_http_3_ecn_ce_ect0_ratio_sent`
                            
                                ) AS `custom_distribution`
                            , 
                                STRUCT(
                                    metrics.url2.search_engine_default_submission_url, metrics.url2.search_engine_private_submission_url
                                ) AS `url2`
                            , 
                                STRUCT(
                                    
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_length_changed.denominator, metrics.rate.rtcrtpsender_setparameters_fail_length_changed.numerator
                                ) AS `rtcrtpsender_setparameters_fail_length_changed`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_no_encodings.denominator, metrics.rate.rtcrtpsender_setparameters_fail_no_encodings.numerator
                                ) AS `rtcrtpsender_setparameters_fail_no_encodings`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_no_getparameters.denominator, metrics.rate.rtcrtpsender_setparameters_fail_no_getparameters.numerator
                                ) AS `rtcrtpsender_setparameters_fail_no_getparameters`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_no_transactionid.denominator, metrics.rate.rtcrtpsender_setparameters_fail_no_transactionid.numerator
                                ) AS `rtcrtpsender_setparameters_fail_no_transactionid`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_other.denominator, metrics.rate.rtcrtpsender_setparameters_fail_other.numerator
                                ) AS `rtcrtpsender_setparameters_fail_other`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_rid_changed.denominator, metrics.rate.rtcrtpsender_setparameters_fail_rid_changed.numerator
                                ) AS `rtcrtpsender_setparameters_fail_rid_changed`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_fail_stale_transactionid.denominator, metrics.rate.rtcrtpsender_setparameters_fail_stale_transactionid.numerator
                                ) AS `rtcrtpsender_setparameters_fail_stale_transactionid`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_warn_length_changed.denominator, metrics.rate.rtcrtpsender_setparameters_warn_length_changed.numerator
                                ) AS `rtcrtpsender_setparameters_warn_length_changed`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_warn_no_getparameters.denominator, metrics.rate.rtcrtpsender_setparameters_warn_no_getparameters.numerator
                                ) AS `rtcrtpsender_setparameters_warn_no_getparameters`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_warn_no_transactionid.denominator, metrics.rate.rtcrtpsender_setparameters_warn_no_transactionid.numerator
                                ) AS `rtcrtpsender_setparameters_warn_no_transactionid`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_warn_rid_changed.denominator, metrics.rate.rtcrtpsender_setparameters_warn_rid_changed.numerator
                                ) AS `rtcrtpsender_setparameters_warn_rid_changed`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_setparameters_warn_stale_transactionid.denominator, metrics.rate.rtcrtpsender_setparameters_warn_stale_transactionid.numerator
                                ) AS `rtcrtpsender_setparameters_warn_stale_transactionid`
                            , 
                                STRUCT(
                                    metrics.rate.rtcrtpsender_used_sendencodings.denominator, metrics.rate.rtcrtpsender_used_sendencodings.numerator
                                ) AS `rtcrtpsender_used_sendencodings`
                            , 
                                STRUCT(
                                    metrics.rate.translations_error_rate.denominator, metrics.rate.translations_error_rate.numerator
                                ) AS `translations_error_rate`
                            , 
                                STRUCT(
                                    metrics.rate.cookie_banners_cmp_ratio_handled_by_cmp_rule.denominator, metrics.rate.cookie_banners_cmp_ratio_handled_by_cmp_rule.numerator
                                ) AS `cookie_banners_cmp_ratio_handled_by_cmp_rule`
                            , 
                                STRUCT(
                                    metrics.rate.networking_set_cookie_foreign.denominator, metrics.rate.networking_set_cookie_foreign.numerator
                                ) AS `networking_set_cookie_foreign`
                            , 
                                STRUCT(
                                    metrics.rate.networking_set_cookie_foreign_partitioned.denominator, metrics.rate.networking_set_cookie_foreign_partitioned.numerator
                                ) AS `networking_set_cookie_foreign_partitioned`
                            , 
                                STRUCT(
                                    metrics.rate.networking_set_cookie_partitioned.denominator, metrics.rate.networking_set_cookie_partitioned.numerator
                                ) AS `networking_set_cookie_partitioned`
                            , 
                                STRUCT(
                                    metrics.rate.verification_used_cert_from_built_in_roots_module.denominator, metrics.rate.verification_used_cert_from_built_in_roots_module.numerator
                                ) AS `verification_used_cert_from_built_in_roots_module`
                            , 
                                STRUCT(
                                    metrics.rate.verification_used_cert_from_nss_cert_db.denominator, metrics.rate.verification_used_cert_from_nss_cert_db.numerator
                                ) AS `verification_used_cert_from_nss_cert_db`
                            , 
                                STRUCT(
                                    metrics.rate.verification_used_cert_from_preloaded_intermediates.denominator, metrics.rate.verification_used_cert_from_preloaded_intermediates.numerator
                                ) AS `verification_used_cert_from_preloaded_intermediates`
                            , 
                                STRUCT(
                                    metrics.rate.verification_used_cert_from_third_party_certificates.denominator, metrics.rate.verification_used_cert_from_third_party_certificates.numerator
                                ) AS `verification_used_cert_from_third_party_certificates`
                            , 
                                STRUCT(
                                    metrics.rate.verification_used_cert_from_tls_handshake.denominator, metrics.rate.verification_used_cert_from_tls_handshake.numerator
                                ) AS `verification_used_cert_from_tls_handshake`
                            , 
                                STRUCT(
                                    metrics.rate.httpsfirst_downgraded_on_timer.denominator, metrics.rate.httpsfirst_downgraded_on_timer.numerator
                                ) AS `httpsfirst_downgraded_on_timer`
                            , 
                                STRUCT(
                                    metrics.rate.httpsfirst_downgraded_on_timer_schemeless.denominator, metrics.rate.httpsfirst_downgraded_on_timer_schemeless.numerator
                                ) AS `httpsfirst_downgraded_on_timer_schemeless`
                            , 
                                STRUCT(
                                    metrics.rate.private_browsing_window_open_during_teardown.denominator, metrics.rate.private_browsing_window_open_during_teardown.numerator
                                ) AS `private_browsing_window_open_during_teardown`
                            , 
                                STRUCT(
                                    metrics.rate.pkcs11_built_in_roots_module.denominator, metrics.rate.pkcs11_built_in_roots_module.numerator
                                ) AS `pkcs11_built_in_roots_module`
                            , 
                                STRUCT(
                                    metrics.rate.pkcs11_nss_cert_db.denominator, metrics.rate.pkcs11_nss_cert_db.numerator
                                ) AS `pkcs11_nss_cert_db`
                            , 
                                STRUCT(
                                    metrics.rate.networking_set_cookie_expired_without_server_time.denominator, metrics.rate.networking_set_cookie_expired_without_server_time.numerator
                                ) AS `networking_set_cookie_expired_without_server_time`
                            , 
                                STRUCT(
                                    metrics.rate.parsing_svg_unusual_pcdata.denominator, metrics.rate.parsing_svg_unusual_pcdata.numerator
                                ) AS `parsing_svg_unusual_pcdata`
                            , 
                                STRUCT(
                                    metrics.rate.cert_signature_cache_hits.denominator, metrics.rate.cert_signature_cache_hits.numerator
                                ) AS `cert_signature_cache_hits`
                            , 
                                STRUCT(
                                    metrics.rate.sct_signature_cache_hits.denominator, metrics.rate.sct_signature_cache_hits.numerator
                                ) AS `sct_signature_cache_hits`
                            , 
                                STRUCT(
                                    metrics.rate.cert_trust_cache_hits.denominator, metrics.rate.cert_trust_cache_hits.numerator
                                ) AS `cert_trust_cache_hits`
                            
                                ) AS `rate`
                            , 
                                STRUCT(
                                    metrics.string_list.background_update_reasons_to_not_update, metrics.string_list.browser_migration_matched_extensions, metrics.string_list.browser_migration_unmatched_extensions
                                ) AS `string_list`
                            , 
                                STRUCT(
                                    metrics.object.fog_validation_some_object, metrics.object.browser_ui_toolbar_widgets
                                ) AS `object`
                            , 
                                STRUCT(
                                    
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            cookie_banners_google_gdpr_choice_cookie.key, cookie_banners_google_gdpr_choice_cookie.value
                                        )
                                    FROM UNNEST(metrics.labeled_string.cookie_banners_google_gdpr_choice_cookie) AS `cookie_banners_google_gdpr_choice_cookie`
                                ) AS `cookie_banners_google_gdpr_choice_cookie`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            places_places_database_corruption_handling_stage.key, places_places_database_corruption_handling_stage.value
                                        )
                                    FROM UNNEST(metrics.labeled_string.places_places_database_corruption_handling_stage) AS `places_places_database_corruption_handling_stage`
                                ) AS `places_places_database_corruption_handling_stage`
                            
                                ) AS `labeled_string`
                            , 
                                STRUCT(
                                    
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_http3_complete_load.key, 
                                STRUCT(
                                    network_http3_complete_load.value.bucket_count, network_http3_complete_load.value.count, network_http3_complete_load.value.histogram_type, network_http3_complete_load.value.overflow, network_http3_complete_load.value.range, network_http3_complete_load.value.sum, network_http3_complete_load.value.time_unit, network_http3_complete_load.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_http3_complete_load.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.network_http3_complete_load) AS `network_http3_complete_load`
                                ) AS `network_http3_complete_load`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_http3_first_sent_to_last_received.key, 
                                STRUCT(
                                    network_http3_first_sent_to_last_received.value.bucket_count, network_http3_first_sent_to_last_received.value.count, network_http3_first_sent_to_last_received.value.histogram_type, network_http3_first_sent_to_last_received.value.overflow, network_http3_first_sent_to_last_received.value.range, network_http3_first_sent_to_last_received.value.sum, network_http3_first_sent_to_last_received.value.time_unit, network_http3_first_sent_to_last_received.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_http3_first_sent_to_last_received.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.network_http3_first_sent_to_last_received) AS `network_http3_first_sent_to_last_received`
                                ) AS `network_http3_first_sent_to_last_received`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_http3_open_to_first_received.key, 
                                STRUCT(
                                    network_http3_open_to_first_received.value.bucket_count, network_http3_open_to_first_received.value.count, network_http3_open_to_first_received.value.histogram_type, network_http3_open_to_first_received.value.overflow, network_http3_open_to_first_received.value.range, network_http3_open_to_first_received.value.sum, network_http3_open_to_first_received.value.time_unit, network_http3_open_to_first_received.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_http3_open_to_first_received.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.network_http3_open_to_first_received) AS `network_http3_open_to_first_received`
                                ) AS `network_http3_open_to_first_received`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_http3_open_to_first_sent.key, 
                                STRUCT(
                                    network_http3_open_to_first_sent.value.bucket_count, network_http3_open_to_first_sent.value.count, network_http3_open_to_first_sent.value.histogram_type, network_http3_open_to_first_sent.value.overflow, network_http3_open_to_first_sent.value.range, network_http3_open_to_first_sent.value.sum, network_http3_open_to_first_sent.value.time_unit, network_http3_open_to_first_sent.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_http3_open_to_first_sent.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.network_http3_open_to_first_sent) AS `network_http3_open_to_first_sent`
                                ) AS `network_http3_open_to_first_sent`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_http3_tls_handshake.key, 
                                STRUCT(
                                    network_http3_tls_handshake.value.bucket_count, network_http3_tls_handshake.value.count, network_http3_tls_handshake.value.histogram_type, network_http3_tls_handshake.value.overflow, network_http3_tls_handshake.value.range, network_http3_tls_handshake.value.sum, network_http3_tls_handshake.value.time_unit, network_http3_tls_handshake.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_http3_tls_handshake.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.network_http3_tls_handshake) AS `network_http3_tls_handshake`
                                ) AS `network_http3_tls_handshake`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_sup_http3_tcp_connection.key, 
                                STRUCT(
                                    network_sup_http3_tcp_connection.value.bucket_count, network_sup_http3_tcp_connection.value.count, network_sup_http3_tcp_connection.value.histogram_type, network_sup_http3_tcp_connection.value.overflow, network_sup_http3_tcp_connection.value.range, network_sup_http3_tcp_connection.value.sum, network_sup_http3_tcp_connection.value.time_unit, network_sup_http3_tcp_connection.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_sup_http3_tcp_connection.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.network_sup_http3_tcp_connection) AS `network_sup_http3_tcp_connection`
                                ) AS `network_sup_http3_tcp_connection`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_http3_0rtt_state_duration.key, 
                                STRUCT(
                                    netwerk_http3_0rtt_state_duration.value.bucket_count, netwerk_http3_0rtt_state_duration.value.count, netwerk_http3_0rtt_state_duration.value.histogram_type, netwerk_http3_0rtt_state_duration.value.overflow, netwerk_http3_0rtt_state_duration.value.range, netwerk_http3_0rtt_state_duration.value.sum, netwerk_http3_0rtt_state_duration.value.time_unit, netwerk_http3_0rtt_state_duration.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(netwerk_http3_0rtt_state_duration.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.netwerk_http3_0rtt_state_duration) AS `netwerk_http3_0rtt_state_duration`
                                ) AS `netwerk_http3_0rtt_state_duration`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            suggest_ingest_download_time.key, 
                                STRUCT(
                                    suggest_ingest_download_time.value.bucket_count, suggest_ingest_download_time.value.count, suggest_ingest_download_time.value.histogram_type, suggest_ingest_download_time.value.overflow, suggest_ingest_download_time.value.range, suggest_ingest_download_time.value.sum, suggest_ingest_download_time.value.time_unit, suggest_ingest_download_time.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(suggest_ingest_download_time.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.suggest_ingest_download_time) AS `suggest_ingest_download_time`
                                ) AS `suggest_ingest_download_time`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            suggest_ingest_time.key, 
                                STRUCT(
                                    suggest_ingest_time.value.bucket_count, suggest_ingest_time.value.count, suggest_ingest_time.value.histogram_type, suggest_ingest_time.value.overflow, suggest_ingest_time.value.range, suggest_ingest_time.value.sum, suggest_ingest_time.value.time_unit, suggest_ingest_time.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(suggest_ingest_time.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.suggest_ingest_time) AS `suggest_ingest_time`
                                ) AS `suggest_ingest_time`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            suggest_query_time.key, 
                                STRUCT(
                                    suggest_query_time.value.bucket_count, suggest_query_time.value.count, suggest_query_time.value.histogram_type, suggest_query_time.value.overflow, suggest_query_time.value.range, suggest_query_time.value.sum, suggest_query_time.value.time_unit, suggest_query_time.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(suggest_query_time.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.suggest_query_time) AS `suggest_query_time`
                                ) AS `suggest_query_time`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_trr_fetch_duration.key, 
                                STRUCT(
                                    networking_trr_fetch_duration.value.bucket_count, networking_trr_fetch_duration.value.count, networking_trr_fetch_duration.value.histogram_type, networking_trr_fetch_duration.value.overflow, networking_trr_fetch_duration.value.range, networking_trr_fetch_duration.value.sum, networking_trr_fetch_duration.value.time_unit, networking_trr_fetch_duration.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(networking_trr_fetch_duration.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.networking_trr_fetch_duration) AS `networking_trr_fetch_duration`
                                ) AS `networking_trr_fetch_duration`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            netwerk_http3_time_to_reuse_idle_connection.key, 
                                STRUCT(
                                    netwerk_http3_time_to_reuse_idle_connection.value.bucket_count, netwerk_http3_time_to_reuse_idle_connection.value.count, netwerk_http3_time_to_reuse_idle_connection.value.histogram_type, netwerk_http3_time_to_reuse_idle_connection.value.overflow, netwerk_http3_time_to_reuse_idle_connection.value.range, netwerk_http3_time_to_reuse_idle_connection.value.sum, netwerk_http3_time_to_reuse_idle_connection.value.time_unit, netwerk_http3_time_to_reuse_idle_connection.value.underflow, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(netwerk_http3_time_to_reuse_idle_connection.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_timing_distribution.netwerk_http3_time_to_reuse_idle_connection) AS `netwerk_http3_time_to_reuse_idle_connection`
                                ) AS `netwerk_http3_time_to_reuse_idle_connection`
                            
                                ) AS `labeled_timing_distribution`
                            , 
                                STRUCT(
                                    
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            networking_http_3_ecn_ce_ect0_ratio.key, 
                                STRUCT(
                                    networking_http_3_ecn_ce_ect0_ratio.value.count, networking_http_3_ecn_ce_ect0_ratio.value.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(networking_http_3_ecn_ce_ect0_ratio.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_custom_distribution.networking_http_3_ecn_ce_ect0_ratio) AS `networking_http_3_ecn_ce_ect0_ratio`
                                ) AS `networking_http_3_ecn_ce_ect0_ratio`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            quotamanager_initialize_repository_number_of_iterations.key, 
                                STRUCT(
                                    quotamanager_initialize_repository_number_of_iterations.value.count, quotamanager_initialize_repository_number_of_iterations.value.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(quotamanager_initialize_repository_number_of_iterations.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_custom_distribution.quotamanager_initialize_repository_number_of_iterations) AS `quotamanager_initialize_repository_number_of_iterations`
                                ) AS `quotamanager_initialize_repository_number_of_iterations`
                            , 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            network_cache_hit_rate_per_cache_size.key, 
                                STRUCT(
                                    network_cache_hit_rate_per_cache_size.value.count, network_cache_hit_rate_per_cache_size.value.sum, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            values.key, values.value
                                        )
                                    FROM UNNEST(network_cache_hit_rate_per_cache_size.value.values) AS `values`
                                ) AS `values`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(metrics.labeled_custom_distribution.network_cache_hit_rate_per_cache_size) AS `network_cache_hit_rate_per_cache_size`
                                ) AS `network_cache_hit_rate_per_cache_size`
                            
                                ) AS `labeled_custom_distribution`
                            
                                ) AS `metrics`
                            , normalized_app_name, normalized_channel, normalized_country_code, normalized_os, normalized_os_version, 
                                STRUCT(
                                    ping_info.end_time, 
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            experiments.key, 
                                STRUCT(
                                    experiments.value.branch, 
                                STRUCT(
                                    experiments.value.extra.type, experiments.value.extra.enrollment_id
                                ) AS `extra`
                            
                                ) AS `value`
                            
                                        )
                                    FROM UNNEST(ping_info.experiments) AS `experiments`
                                ) AS `experiments`
                            , ping_info.ping_type, ping_info.reason, ping_info.seq, ping_info.start_time
                                ) AS `ping_info`
                            , sample_id, submission_timestamp
        FROM
          `moz-fx-data-backfill-1.firefox_desktop_stable.metrics_v1`
        WHERE
          DATE(submission_timestamp) > "2024-10-01"
        
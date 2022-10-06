#!/bin/bash
set -exo pipefail

# This script assumes it's being run from the bigquery-etl repo, and that 02-gcp-ingestion-beam-decoder.sh
# was run and the associated Dataflow job completed successfully.

PROJECT="moz-fx-data-backfill-10"
TABLES=(
  org_mozilla_firefox_stable.logins_sync_v1
  org_mozilla_fenix_stable.events_v1
  org_mozilla_firefox_stable.bookmarks_sync_v1
  org_mozilla_fenix_stable.topsites_impression_v1
  org_mozilla_fenix_stable.startup_timeline_v1
  org_mozilla_firefox_stable.creditcards_sync_v1
  org_mozilla_ios_firefox_stable.events_v1
  org_mozilla_firefox_stable.sync_v1
  org_mozilla_focus_stable.events_v1
  firefox_desktop_stable.events_v1
  org_mozilla_ios_firefox_stable.metrics_v1
  org_mozilla_ios_firefox_stable.topsites_impression_v1
  org_mozilla_ios_firefox_stable.temp_clients_sync_v1
  org_mozilla_ios_firefox_stable.temp_bookmarks_sync_v1
  org_mozilla_ios_firefox_stable.baseline_v1
  org_mozilla_ios_firefox_stable.temp_tabs_sync_v1
  org_mozilla_fenix_stable.tabs_sync_v1
  org_mozilla_firefox_beta_stable.tabs_sync_v1
  org_mozilla_ios_firefoxbeta_stable.baseline_v1
  org_mozilla_firefox_stable.startup_timeline_v1
  org_mozilla_ios_firefox_stable.temp_sync_v1
  org_mozilla_fenix_stable.baseline_v1
  org_mozilla_fennec_aurora_stable.metrics_v1
  org_mozilla_firefox_stable.events_v1
  org_mozilla_focus_stable.metrics_v1
  activity_stream_stable.events_v1
  firefox_desktop_background_update_stable.deletion_request_v1
  firefox_desktop_stable.newtab_v1
  default_browser_agent_stable.default_browser_v1
  org_mozilla_firefox_stable.metrics_v1
  firefox_installer_stable.install_v1
  org_mozilla_firefox_stable.baseline_v1
  org_mozilla_firefox_stable.topsites_impression_v1
  org_mozilla_ios_focus_stable.events_v1
  org_mozilla_firefox_beta_stable.events_v1
  org_mozilla_firefox_stable.tabs_sync_v1
  org_mozilla_ios_focus_stable.metrics_v1
  activity_stream_stable.sessions_v1
  org_mozilla_firefox_beta_stable.baseline_v1
  activity_stream_stable.impression_stats_v1
  org_mozilla_firefox_stable.activation_v1
  regrets_reporter_ucs_stable.video_data_v1
  org_mozilla_firefox_beta_stable.creditcards_sync_v1
  org_mozilla_ios_klar_stable.baseline_v1
  org_mozilla_fennec_aurora_stable.startup_timeline_v1
  org_mozilla_focus_stable.baseline_v1
  firefox_desktop_stable.baseline_v1
  org_mozilla_ios_firefox_stable.temp_logins_sync_v1
  org_mozilla_firefox_beta_stable.startup_timeline_v1
  org_mozilla_ios_firefox_stable.temp_history_sync_v1
  messaging_system_stable.undesired_events_v1
  firefox_desktop_background_update_stable.background_update_v1
  org_mozilla_ios_firefox_stable.temp_rust_tabs_sync_v1
  org_mozilla_ios_firefoxbeta_stable.events_v1
  org_mozilla_fenix_stable.sync_v1
  firefox_desktop_stable.metrics_v1
  org_mozilla_tv_firefox_stable.baseline_v1
  firefox_desktop_background_update_stable.baseline_v1
  contextual_services_stable.topsites_impression_v1
  org_mozilla_ios_focus_stable.baseline_v1
  contextual_services_stable.topsites_click_v1
  org_mozilla_firefox_stable.history_sync_v1
)

DATES=(
    2022-08-31
)

# may fail, see https://github.com/mozilla/bigquery-etl/issues/3255
./bqetl copy_deduplicate \
  --project-id $PROJECT --billing-project $PROJECT \
  -o "${TABLES[@]}" \
  --dates "${DATES[@]}"

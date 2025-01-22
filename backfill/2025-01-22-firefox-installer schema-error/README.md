# 2025-01-22 Firefox installer schema errors

Bug for error: https://bugzilla.mozilla.org/show_bug.cgi?id=1934302
Bug for backfill: https://bugzilla.mozilla.org/show_bug.cgi?id=1941442

In Firefox 134, some new fields were added to the Firefox installer telemetry.
This includes `firefox-installer.install` and `stub_installer` pings.  

Bug for error: https://bugzilla.mozilla.org/show_bug.cgi?id=1934302

Bug for backfill: https://bugzilla.mozilla.org/show_bug.cgi?id=1941442

In Firefox 134, some new fields were added to the Firefox installer telemetry.  This includes `firefox_installer.install` and `stub_installer` pings.  These pings go through different pipelines but both end up in `firefox_installer_live.install_v1`.

Schema change for `firefox-installer.install`: https://github.com/mozilla-services/mozilla-pipeline-schemas/pull/828

Ingestion change for `stub_installer`: https://github.com/mozilla/gcp-ingestion/pull/2638

The issue for `firefox_installer.install` was that the `windows_ubr` field was set as an integer in the schema, but the client was sending them as strings.  The issue with the stub installer was that the ping version wasn’t incremented when the new field were added.  The expected number of fields is based on the version in the ping.  This resulted in all pings coming from Firefox 134 to fail validation.  
Since this is a client-side issue, the pings are still invalid and we can’t rerun the errors through the regular decoder, as they’ll still fail.  To make the ingestion work, we will need to make some workarounds in the decoder to coerce these pings into a valid format.

Client-side fix was released in Firefox 134.0.2: https://phabricator.services.mozilla.com/D233944

Steps for backfill:

1. Setup backfill project
2. Make changes to decoder to modify pings
3. Run affected pings through decoder, writing to staging tables
4. Dedupe staging table
5. Insert into stable table

WIP

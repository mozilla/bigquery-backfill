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

1. Set up backfill project
2. Make changes to decoder to modify pings
3. Run affected pings through decoder, writing to staging tables
4. Dedupe staging table
5. Insert into stable table

## Set up backfill project

We need to set permissions in a backfill project and copy over the errored rows from `payload_bytes_error`.
We can do this in terraform with the backfill project: https://github.com/mozilla-services/cloudops-infra/pull/6194

The queries to get the affected pings are:
```sql
SELECT
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error_structured`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
  AND document_namespace = "firefox-installer"
  AND document_type = "install"
  AND error_message = "org.everit.json.schema.ValidationException: #/windows_ubr: expected type: Integer, found: String"
```
and
```sql
SELECT
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.stub_installer`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
  AND error_message LIKE "com.mozilla.telemetry.decoder.ParseUri$UnexpectedPathElementsException: Found 2 more path elements in the URI than expected for this endpoint"
```

## Decoder changes

We need to make some temporary workarounds in the decoder to make the errored pings pass validation.
The changes are:
- Cast `windows_ubr` to an integer for `firefox-installer.install`
- Change the ping version of `stub_installer` pings to v10 so it expects 43 fields

These changes shouldn't be merged to prod and can just be deployed manually for the backfill.

PR for workaround: https://github.com/mozilla/gcp-ingestion/pull/2720

## 

# 2025-01-22 Firefox installer schema errors

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
4. Validate and dedupe staging table
5. Insert into prod stable table

## Set up backfill project

We need to set permissions in a backfill project and copy over the errored rows from `payload_bytes_error`.
We can do this in terraform with the backfill project: https://github.com/mozilla-services/cloudops-infra/pull/6194
The config in the PR will only copy firefox-installer error so the stub installer errors need to be copied manually:

```sql
INSERT INTO `moz-fx-data-backfill-1.payload_bytes_error.backfill`
SELECT
  -- list all the columns because the column order is different
  args, client_id, content_length, `date`, dnt, document_namespace, document_type, document_version, error_message, error_type, exception_class, geo_city, geo_country, geo_subdivision1, geo_subdivision2, host, input, input_type, isp_name, isp_organization, job_name, method, payload, protocol, remote_addr, stack_trace, stack_trace_cause_1, stack_trace_cause_2, stack_trace_cause_3, stack_trace_cause_4, stack_trace_cause_5, submission_timestamp, uri, user_agent, user_agent_browser, user_agent_os, user_agent_version, x_debug_id, x_forwarded_for, x_foxsec_ip_reputation, x_lb_tags, x_pingsender_version, x_pipeline_proxy, x_source_tags, x_telemetry_agent
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.stub_installer`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
  AND error_message LIKE "com.mozilla.telemetry.decoder.ParseUri$UnexpectedPathElementsException: Found 2 more path elements in the URI than expected for this endpoint"
```

Affected firefox-install pings:
```sql
SELECT
  *
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.structured`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
  AND document_namespace = "firefox-installer"
  AND document_type = "install"
  AND error_message = "org.everit.json.schema.ValidationException: #/windows_ubr: expected type: Integer, found: String"
```

## Decoder changes

We need to make some temporary workarounds in the decoder to make the errored pings pass validation.
The changes are:
- Cast `windows_ubr` to an integer for `firefox-installer.install`
- Change the ping version of `stub_installer` pings to v10 so it expects 43 fields

These changes shouldn't be merged to prod and can just be deployed manually for the backfill.

PR for workaround: https://github.com/mozilla/gcp-ingestion/pull/2720

## Deploy decoder job

The job can be deployed to dataflow using [start_dataflow_20250122.sh](./start_dataflow_20250122.sh),
running from `ingestion-beam/` in `gcp-ingestion`. e.g.:

```
ingestion-beam % ./start_dataflow_20250122.sh
```

Note: I needed to run `gcloud auth application-default set-quota-project moz-fx-data-backfill-1`

Note 2: I had some runs with incorrect arguments and decoder changes so I needed to clear out the output tables between runs:
```sql
TRUNCATE TABLE `moz-fx-data-backfill-1.firefox_installer_live.install_v1`;
TRUNCATE TABLE `moz-fx-data-backfill-1.payload_bytes_error.structured`;
```

## Validation

The dataflow job will output the processed pings to `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
and errors will go to `moz-fx-data-backfill-1.payload_bytes_error.structured`.

There are 81 127 rows in `moz-fx-data-backfill-1.payload_bytes_error.structured` so we should check those
to see if those are valid pings and the decoder logic needs to be fixed.

```sql
SELECT
  COUNT(*),
  error_message,
FROM
  `moz-fx-data-backfill-1.payload_bytes_error.structured`
WHERE
  submission_timestamp > "2024-12-30"
GROUP BY
  error_message
```

The error messages all `com.mozilla.telemetry.decoder.ParseUri$StubUri$InvalidIntegerException: Path element #17: ` or another
element #.  These are stub installer errors where the URI had empty elements where it expected an integer so these are
valid errors.  These errors account for 4.7% of the reingested stub installer pings.

The new fields are correctly being populated, matching the values in the payload (for full installer) or the URI (for stub):
```sql
SELECT
  COUNT(*),
  ping_version,
  windows_ubr,
  stub_build_id,
FROM
  `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
WHERE
  DATE(submission_timestamp) < "2025-01-23"
GROUP BY ALL
```

Using [null_field_ratio.sql](./null_field_ratio.sql), the null ratios approximately match the live data.

## Dedupe

We need to dedupe by document id within `moz-fx-data-backfill-1.firefox_installer_live.install_v1` and also 
make sure the document ids aren't already in `moz-fx-data-shared-prod.firefox_installer_stable.install_v1`.
We will maintain the same semantics, deduping doc ids per day, not across the whole backfill interval.  

We can see that there are 2026 duplicates within the backfill data ([duplicates1.sql](./duplicates1.sql))
and there are an additional 95 rows that are duplicated in the stable table ([duplicates2.sql](./duplicates2.sql)).
A spot check shows that the one in the stable table are actually different pings with different data, but they're considered duplicates anyway.

Backfill query (ensure `moz-fx-data-backfill-1.firefox_installer_stable.install_v1` is empty first):
```sql
WITH backfill AS (
  SELECT
    *
  FROM
    `moz-fx-data-backfill-1.firefox_installer_live.install_v1`
  WHERE
    DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
  QUALIFY
    ROW_NUMBER() OVER (PARTITION BY document_id, DATE(submission_timestamp) ORDER BY submission_timestamp) = 1
),
stable AS (
  SELECT
    DATE(submission_timestamp) AS submission_date,
    document_id,
  FROM
    `moz-fx-data-shared-prod.firefox_installer_stable.install_v1`
  WHERE
    DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"
)

SELECT
  backfill.*,
FROM
  backfill
LEFT JOIN
  stable
ON
  backfill.document_id = stable.document_id
  AND DATE(backfill.submission_timestamp) = stable.submission_date
WHERE
  stable.submission_date IS NULL
```
This inserts 12 171 249 rows into `moz-fx-data-backfill-1.firefox_installer_stable.install_v1`.

## Insert into prod stable table

This step requires DSRE assistance to write to the stable table (https://mozilla-hub.atlassian.net/browse/DSRE-1892).  
The backfill staging table is deduped, so to insert into the prod table, we can run a `SELECT *` with a destination table:
```
bq query \
  --nouse_legacy_sql \
  --destination_table 'moz-fx-data-shared-prod:firefox_installer_stable.install_v1' \
  --append_table=true \
  'SELECT * FROM `moz-fx-data-backfill-1.firefox_installer_stable.install_v1` WHERE DATE(submission_timestamp) BETWEEN "2024-12-30" AND "2025-01-22"'
```

Alternatively, we could use an `INSERT` statement, but that requires the columns in both tables to be in the same order,
which they are not because the prod table has columns added to the end of the schema.  We could explicitly list the columns
but that's potentially more error-prone.

## Validate stable table

We can look at `moz-fx-data-shared-prod:firefox_installer_stable.install_v1` to check that the data looks as expected.

Ping count by version:
```sql
SELECT
  COUNT(*) AS ping_count,
  version,
  DATE(submission_timestamp) AS submission_date,
FROM
  `moz-fx-data-shared-prod.firefox_installer_stable.install_v1`
WHERE
  DATE(submission_timestamp) >= "2024-12-20"
GROUP BY ALL
HAVING
  ping_count > 50
```
https://sql.telemetry.mozilla.org/queries/104802/source#258025

This shows that the ping count from version 134.0 now looks as expected.

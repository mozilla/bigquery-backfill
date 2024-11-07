# 2024-11-06 Metric Pings with metric labels over the maxLength of 61

Starting at around 2024-10-27, there was an increase of `ValidationExceptions` due to newly added metric label names exceeding the character limit of 61: `org.everit.json.schema.ValidationException: #/metrics/labeled_boolean/browser.ui.mirror_for_toolbar_widgets/<some long label>: expected maxLength: 61, actual: <some number bigger than 61>`. A [PR was merged in 2019 to increase this limit to 71](https://github.com/mozilla-services/mozilla-pipeline-schemas/pull/408/files), however the PR was merged into the `mozilla-services:dev` branch, and never landed in `main`.

On 2024-11-04, a [fix](https://bugzilla.mozilla.org/attachment.cgi?id=9435189) landed to update the JSON schemas to allow for up to 71 character in metric label names.

See [Bug 1929078](https://bugzilla.mozilla.org/show_bug.cgi?id=1929078) for more information.

The steps to backfill are:
1. Run the affected pings through the decoder dataflow job, writing to staging tables
2. Dedupe the staging tables 
3. Insert into the stable tables (requires SRE assistance)

## Affected Pings

To find the affected ping volume and dates, we can look in `moz-fx-data-shared-prod.monitoring.payload_bytes_error_structured`:

```sql
SELECT
  DATE(submission_timestamp) AS d,
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.monitoring.payload_bytes_error_structured`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
  AND
    error_message LIKE 'org.everit.json.schema.ValidationException: #/metrics/% expected maxLength: 61, actual: %'
GROUP BY d
ORDER BY d
```

Only `metrics` pings are affected, as confirmed by the following query:

```sql
SELECT
  document_type,
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.monitoring.payload_bytes_error_structured`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
  AND error_message LIKE 'org.everit.json.schema.ValidationException: #/metrics/% expected maxLength: 61, actual: %'
GROUP BY
  document_type
ORDER BY
  2 DESC
```

Only, `firefox-desktop` is affected:

```sql
SELECT
  document_namespace,
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.monitoring.payload_bytes_error_structured`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
  AND error_message LIKE 'org.everit.json.schema.ValidationException: #/metrics/% expected maxLength: 61, actual: %'
GROUP BY
  document_namespace
ORDER BY
  2 DESC

-- The 11 org-mozilla-firefox pings that show up are all unrelated to this specific issue and exceed the label length by much more:
--
-- SELECT
--   document_namespace,
--   error_message
-- FROM
--   `moz-fx-data-shared-prod.monitoring.payload_bytes_error_structured`
-- WHERE
--   DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
--   AND error_message LIKE 'org.everit.json.schema.ValidationException: #/metrics/% expected maxLength: 61, actual: %'
--   AND document_namespace = "org-mozilla-firefox"
-- ORDER BY
--   2 DESC
```

## Setting up the Backfill Project

To grant dataset creation permissions and to get access to `payload_bytes_error`: https://github.com/mozilla-services/cloudops-infra/pull/6055

## Reingest Using Decoder

To start, we need to create the temporary datasets and tables to use as dataflow input, output, and error.
We can do that by running the script at 
[`mirror-prod-tables.sh`](mirror-prod-tables.sh).

This will create the datasets `firefox_desktop_metrics_output`, `firefox_desktop_metrics_deduped`, and 
`payload_bytes_error_firefox_desktop_metrics`.

We will then create a `payload_bytes_error`-like table with only the rows that we want to reprocess:

```sql
CREATE TABLE 
    moz-fx-data-backfill-1.payload_bytes_error_firefox_desktop_metrics.structured_input
LIKE 
    moz-fx-data-backfill-1.payload_bytes_error_firefox_desktop_metrics.structured
AS
(
  SELECT 
    *
  FROM 
    `moz-fx-data-shared-prod.payload_bytes_error.structured` 
  WHERE 
    DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
    AND error_message LIKE 'org.everit.json.schema.ValidationException: #/metrics/% expected maxLength: 61, actual: %'
    AND document_namespace = "firefox-desktop"
)
```

The script in [start_dataflow.sh](start_dataflow.sh)
will start the dataflow job when run from the `ingestion-beam/` directory in 
[`gcp-ingestion`](https://github.com/mozilla/gcp-ingestion/tree/main/ingestion-beam).
`gcloud config set project moz-fx-data-backfill-1` may be needed.  
The job will be viewable at https://console.cloud.google.com/dataflow/jobs?project=moz-fx-data-backfill-1

## Dedupe and Insert

The dataflow output will have duplicate document ids, so we need to dedupe before inserting into the stable tables,
similar to copy_deduplicate. We can also check if any document ids already exist in the stable table, just as 
a safeguard. There are no automation pings, so there's no need to filter like in copy_deduplicate.

This will be split into two steps for easier validation.

```sql
CREATE TABLE `moz-fx-data-backfill-1.firefox_desktop_metrics_deduped.metrics_v1` 
LIKE `moz-fx-data-backfill-1.firefox_desktop_metrics_output.metrics_v1` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.firefox_desktop_stable.metrics_v1`
    WHERE 
      DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.firefox_desktop_metrics_output.metrics_v1` 
    WHERE 
      DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
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
```

```sql
INSERT INTO
  `moz-fx-data-shared-prod.firefox_desktop_stable.metrics_v1`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.firefox_desktop_metrics_deduped.metrics_v1`
WHERE 
  DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06";
```


We can dedupe and insert into a staging table with a statement like:
```sql
CREATE TABLE `moz-fx-data-backfill-1.firefox_desktop_metrics_deduped.metrics_v1` 
LIKE `moz-fx-data-backfill-1.firefox_desktop_metrics_output.metrics_v1` AS (
  WITH existing_doc_ids AS (
    SELECT
      document_id
    FROM
      `moz-fx-data-shared-prod.firefox_desktop_stable.metrics_v1`
    WHERE 
      -- look for days after 2024-05-01 to account for late-arriving duplicates
      DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
  ),
  new_rows AS (
    SELECT 
      * 
    FROM 
      `moz-fx-data-backfill-1.firefox_desktop_metrics_output.metrics_v1` 
    WHERE 
      DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06"
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
```

Final counts:

<todo>

Final insert:

```sql
INSERT INTO
  `moz-fx-data-shared-prod.firefox_desktop_stable.metrics_v1`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.firefox_desktop_metrics_deduped.metrics_v1`
WHERE 
  DATE(submission_timestamp) BETWEEN "2024-10-25" AND "2024-11-06";
```

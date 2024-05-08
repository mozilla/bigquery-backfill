# 2024-05-07 telemetry-pings-os-distro

On 2024-01-12, `distro` and `distroVersion` fields were added to `environment.system.os` in the legacy telemetry ping schema
and the sync ping schema in [this PR](https://github.com/mozilla-services/mozilla-pipeline-schemas/pull/799).
This schema requires `distro` and `distroVersion` to be a non-null string if it is included in the payload.
On 2024-01-16, the associated changes landed in Firefox ([bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1874038)).
The implementation didn't correctly pull the value for Arch Linux clients resulting in the `null` value being sent.
These pings (~340k per day) were then all dropped due to failing schema validation.

A fix [for Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=1894412) and 
[the schemas](https://github.com/mozilla-services/mozilla-pipeline-schemas/pull/810) 
were made on 2024-05-01.  We want to backfill the affected pings.

See [incident doc](https://docs.google.com/document/d/1M7ageyDdS8sha0vYTbWwJrsRylrJgUYArjogCpHeL2Q/) for more details.

The steps to backfill are:
1. Run the affected pings through the decoder dataflow job, writing to staging tables
2. Dedupe the staging tables and insert the stable tables

Backfill for derived tables will be handled separately.

## Affected Pings

To find the affected ping volume and dates, we can look in `payload_bytes_error.telemetry`:

```sql
SELECT
  DATE(submission_timestamp) AS d,
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-01-05" AND "2024-05-04"
  AND (
    error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/os/distro%: expected type: String, found: Null'
    OR error_message LIKE 'org.everit.json.schema.ValidationException: #/environment/system/os/distro%: expected type: String, found: Null'
  )
GROUP BY d
ORDER BY d

SELECT
  document_type,
  COUNT(*),
FROM
  `moz-fx-data-shared-prod.payload_bytes_error.telemetry`
WHERE
  DATE(submission_timestamp) BETWEEN "2024-01-05" AND "2024-05-04"
  AND (
    error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/os/distro%: expected type: String, found: Null'
    OR error_message LIKE 'org.everit.json.schema.ValidationException: #/environment/system/os/distro%: expected type: String, found: Null'
  )
GROUP BY
  document_type
ORDER BY
  2 DESC
```

The pings range from 2024-01-16 to 2024-05-01 with the following counts:

| doctype   | error count |
|-----------|-------------|
| event     | 16378606    |
| main      | 9223339     |
| sync      | 3022388     |
| bhr       | 813713      |
| modules   | 458184      |
| new       | 235104      |
| crash     | 220449      |
| first     | 179860      |
| update    | 34881       |
| heartbeat | 3266        |

## Reingest Using Decoder

To start, we need to create the temporary datasets and tables to use as dataflow input, output, and error.
We can do that by running the script at 
[`mirror-prod-tables.sh`](mirror-prod-tables.sh).

This will create the datasets `telemetry_os_distro_output`, `telemetry_os_distro_deduped`, and 
`payload_bytes_error_os_distro`.

We will then create a `payload_bytes_error`-like table with only the rows that we want to reprocess:

```sql
CREATE TABLE 
    moz-fx-data-backfill-1.payload_bytes_error_os_distro.telemetry_input
LIKE 
    moz-fx-data-backfill-1.payload_bytes_error_os_distro.telemetry
AS
(
  SELECT 
    *
  FROM 
    `moz-fx-data-shared-prod.payload_bytes_error.telemetry` 
  WHERE 
    DATE(submission_timestamp) BETWEEN "2024-01-16" AND "2024-05-01"
    AND (
      error_message LIKE 'org.everit.json.schema.ValidationException: #/payload/os/%: expected type: String, found: Null'
      OR error_message LIKE 'org.everit.json.schema.ValidationException: #/environment/system/os/%: expected type: String, found: Null'
    )
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

This will be split into two steps for easier validation.  [`generate_statements.py`](generate_statements.py) will generate
the sql needed.

We can dedupe and insert into a staging table with a statement like:
```sql
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
```

The generated script is in [`dedupe_pings.sql`](dedupe_pings.sql).  Note: this will cost a lot less if run 
with on-demand pricing.

Final counts:

| table                         | raw count | deduped count |
|-------------------------------|-----------|---------------|
| event_v4                      | 	15919980 | 15860174      | 
| main_v5                       | 	9065904  | 9028130       | 
| main_use_counter_v4           | 	9065904  | 9028130       | 
| sync_v4                       | 	3022285  | 3009242       | 
| bhr_v4                        | 	813634   | 812862        | 
| modules_v4                    | 	454503   | 454019        | 
| new_profile_v4                | 	228295   | 227591        | 
| crash_v4                      | 	220374   | 220142        | 
| first_shutdown_use_counter_v4 | 	174975   | 174493        | 
| first_shutdown_v5             | 	174975   | 174493        | 
| update_v4                     | 	34881    | 34542         | 
| heartbeat_v4                  | 	3119     | 3019          |

Final insert:
```sql
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.main_v5`
SELECT
  *
FROM
  `moz-fx-data-backfill-1.telemetry_os_distro_deduped.main_v5`
WHERE 
  DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
```

The generated script is in [`final_insert.sql`](final_insert.sql).

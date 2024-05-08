import subprocess

# use bash to avoid python dependencies
result = subprocess.check_output(
    [
        "bq",
        "query",
        "--format=sparse",
        "--nouse_legacy_sql",
        "--max_rows=1000",
        "SELECT DISTINCT(_TABLE_SUFFIX) FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.*` ORDER BY 1",
    ]
)

tables = result.decode().split()[2:]

CREATE_STATEMENT_TEMPLATE = """-- {table}
CREATE TABLE `moz-fx-data-backfill-1.telemetry_os_distro_deduped.{table}` 
LIKE `moz-fx-data-backfill-1.telemetry_os_distro_output.{table}` AS (
    SELECT *
    FROM `moz-fx-data-backfill-1.telemetry_os_distro_output.{table}`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY submission_timestamp) = 1
);
"""

creates = []

for table in tables:
    creates.append(CREATE_STATEMENT_TEMPLATE.format(table=table))

with open("dedupe_pings.sql", "w") as f:
    f.write("\n".join(creates))

INSERT_STATEMENT_TEMPLATE = """-- {table}
INSERT INTO
  `moz-fx-data-shared-prod.telemetry_stable.{table}`
WITH existing_doc_ids AS (
  SELECT
    document_id
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.{table}`
  WHERE 
    DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
),
new_rows AS (
  SELECT
    *
  FROM
    `moz-fx-data-backfill-1.telemetry_os_distro_deduped.{table}`
  WHERE 
    DATE(submission_timestamp) BETWEEN '2024-01-16' AND '2024-05-02'
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
  existing_doc_ids.document_id IS NULL;
"""

inserts = []

for table in tables:
    inserts.append(INSERT_STATEMENT_TEMPLATE.format(table=table))

with open("final_insert.sql", "w") as f:
    f.write("\n".join(inserts))

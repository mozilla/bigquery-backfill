#!/bin/bash

# This script generates a query to be run via Shredder to rewrite use counter
# histograms into the new encoding.

rm query.sql

cat << 'EOF' >> query.sql
CREATE TEMP FUNCTION
  replace_compact_use_counters(h ANY type) AS ((
    SELECT
      AS STRUCT h.* REPLACE(
EOF

bq show --schema moz-fx-data-shared-prod:telemetry_stable.main_v4 \
    | jq -r '.[] | recurse(.fields[]? + {parent: ((.parent? // []) + [.name])}) | .parent + [.name] | join(".")' \
    | grep use_counter2 \
           > usecounters.txt

cat usecounters.txt | awk -F'.' '{print $NF}' | sort | uniq > usecounters_short.txt

cat usecounters_short.txt \
    | awk '{print "COALESCE(JSON_EXTRACT_SCALAR(h."$1",\"$.sum\"),h."$1") AS "$1","}' \
    | sed 's/AS use_counter2_xmldocument_async_setter_page,/AS use_counter2_xmldocument_async_setter_page/' \
          >> query.sql

cat << 'EOF' >> query.sql
      )));

SELECT
  * REPLACE((
    SELECT
      AS STRUCT payload.* replace (replace_compact_use_counters(payload.histograms) AS histograms,
        (
        SELECT
          AS STRUCT payload.processes.* replace ((
            SELECT
              AS STRUCT payload.processes.content.* REPLACE(replace_compact_use_counters(payload.processes.content.histograms) AS histograms)) AS content)) AS processes )) AS payload)
FROM
  `moz-fx-data-shared-prod.telemetry_stable.main_v4`
WHERE
  DATE(submission_timestamp) = @submission_timestamp
  AND client_id IN (
  SELECT
    client_id
  FROM
    `moz-fx-data-shared-prod.telemetry_stable.deletion_request_v4`
  WHERE
    DATE(submission_timestamp) >= '2020-07-01')
EOF

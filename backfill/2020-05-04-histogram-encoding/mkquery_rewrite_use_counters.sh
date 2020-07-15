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

# Pull the list of full paths to use counter fields from the current prod main_v4 schema.
bq show --schema moz-fx-data-shared-prod:telemetry_stable.main_v4 \
    | jq -r '.[] | recurse(.fields[]? + {parent: ((.parent? // []) + [.name])}) | .parent + [.name] | join(".")' \
    | grep use_counter2 \
           > usecounters.txt

# The exact same set of use counters existing both under payload.histograms and
# under payload.processes.content.histograms, so we want to deduplicate here
# and get just the unique set of short field names without path prefixes.
cat usecounters.txt | awk -F'.' '{print $NF}' | sort | uniq > usecounters_short.txt

# Ideally, we would make a more compact query by wrapping this extraction logic into a
# temporary UDF, but that ends up making the query too complex, so we have to verbosely
# repeat the extraction logic for each field.
# We want this to be robust in case the field is already in the compact encoding, so we
# COALESCE, trying a json extraction first, and otherwise taking the value unmodified.
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

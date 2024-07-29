This query is used to build the `moz-fx-data-shared-prod.telemetry_derived.clients_first_seen_v3`.
This script pulls data from clients_first_seen_v2, except for normalized_os.
Then, based on the first_seen_date_source_ping, the script will pull out columns for os, os_version, isp_name, attribution_variation.
It will also run the os through a normalization udf.
Windows build number is included and run through a UDF to write the windows_version.
Columns for installation_first_seen_* are added as NULL as this data wasn't
collected until July 2024 and are only in the new_profiles_ping.
Start date of this data is 2016-03-12 as that is when clients_first_seen_v2 data began.

Data is checked by comparing counts of client_ids grouped by first_seen_date and first_seen_date_source_ping between `clients_first_seen_v2`
and `clients_first_seen_v3`
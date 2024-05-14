Testing workaround for creating: moz-fx-data-shared-prod.telemetry_derived.desktop_clients_last_seen_v2

Steps Used to Test:
1. Copy clients_last_seen_v1 from prod into analysis 
2. Create a new empty table called ?, then run the backfill from ? to ? just for a few sample IDs
3. Merge the result into clients last seen v1
4. Compare clients last seen v1 with the correct sample IDs 

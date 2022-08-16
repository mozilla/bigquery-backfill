# Backfill clients_first_seen_v1

- [Incident Doc](https://docs.google.com/document/d/1lxkzn0VaFID5OhLiIQIW2GZvrc707oiV0LhU0iifr90/edit#)

The goal is to backfill `telemetry_derived.clients_first_seen_v1` and downstream dependencies.

The script `backfill.py` creates a temporary table for each `sample_id` in parallel and merges the table results in a final step to write them to the destination table.

Execute:

```
python3 backfill/2022-08-15-clients-first-seen/backfill.py --dataset=telemetry_derived --table=clients_first_seen_v1
```

Downstream dependencies can be backfilled via Airflow starting 2022-05-11.

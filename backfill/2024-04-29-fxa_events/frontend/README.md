# Test backfill of backend events
1. Create a copy of events table to test backfill query
```
bq cp moz-fx-data-shared-prod:accounts_frontend_stable.events_v1 mozdata:analysis.akomar_accounts_frontend_events_v1
```
2. Backfill single day of this table
```bash
cat convert_frontend.sql | bq query --project_id=moz-fx-data-shared-prod --parameter=submission_date:DATE:2024-06-01 --use_legacy_sql=false --max_rows=0 --dataset_id=mozdata:analysis --destination_table=akomar_accounts_frontend_events_v1$20240601 --replace
```

Notebook to validate backfilled table:
https://colab.research.google.com/drive/13olbigFxZexoxR_ZHJaiwwr0WoRkKKnw#scrollTo=WiL0KWf22Oof

3. Backfill whole 2024
`events` ping was enabled on 2024-04-17, so we need to backfill up to this date.
```bash
python backfill_frontend_events.py
```
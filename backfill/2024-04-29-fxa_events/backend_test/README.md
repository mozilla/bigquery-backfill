# Test backfill of backend events and users_services_daily table
1. Create a copy of events table to test backfill query
```
bq cp moz-fx-data-shared-prod:accounts_backend_stable.events_v1 mozdata:analysis.akomar_accounts_backend_events_v1
```

2. Backfill single day of this table
```bash
cat convert_backend.sql | bq query --project_id=moz-fx-data-shared-prod --parameter=submission_date:DATE:2024-05-11 --dataset_id=mozdata:analysis --destination_table=akomar_accounts_backend_events_v1$20240511 --use_legacy_sql=false --replace --max_rows=0
```
Notebook to validate backfilled table:
https://colab.research.google.com/drive/107sgCu1I2QMp7HZXa7Vsh6EfaHNvXjii?usp=sharing
Backfilled data looks good. Let's backfill whole 2024 and build users_daily table:

3. Backfill whole 2024
`events` ping was enabled on 2024-04-17, so we need to backfill up to this date.
```bash
python backfill_backend_events.py
```

4. Create copy of users_services_daily table
```bash
bq cp moz-fx-data-shared-prod:accounts_backend_derived.users_services_daily_v1 mozdata:analysis.akomar_accounts_backend_users_services_daily_v2
```

5. backfill users_daily table
```bash
python backfill_backend_users_services_daily.py
```
Validation in the notebook: https://colab.research.google.com/drive/107sgCu1I2QMp7HZXa7Vsh6EfaHNvXjii?usp=sharing
Data looks good, no discrepancies vs production table based on accounts-events.

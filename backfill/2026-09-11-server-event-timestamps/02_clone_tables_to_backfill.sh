#!/bin/bash
set -o xtrace -o errexit -o nounset -o pipefail

bq rm --force --table moz-fx-data-backfill-1:accounts_backend_stable.events_v1
bq cp --project_id=moz-fx-data-backfill-1 --clone --no_clobber \
  moz-fx-data-shared-prod:accounts_backend_stable.events_v1 \
  moz-fx-data-backfill-1:accounts_backend_stable.events_v1

bq rm --force --table moz-fx-data-backfill-1:relay_backend_stable.events_v1
bq cp --project_id=moz-fx-data-backfill-1 --clone --no_clobber \
  moz-fx-data-shared-prod:relay_backend_stable.events_v1 \
  moz-fx-data-backfill-1:relay_backend_stable.events_v1

bq rm --force --table moz-fx-data-backfill-1:subscription_platform_backend_stable.events_v1
bq cp --project_id=moz-fx-data-backfill-1 --clone --no_clobber \
  moz-fx-data-shared-prod:subscription_platform_backend_stable.events_v1 \
  moz-fx-data-backfill-1:subscription_platform_backend_stable.events_v1

bq rm --force --table moz-fx-data-backfill-1:syncstorage_stable.events_v1
bq cp --project_id=moz-fx-data-backfill-1 --clone --no_clobber \
  moz-fx-data-shared-prod:syncstorage_stable.events_v1 \
  moz-fx-data-backfill-1:syncstorage_stable.events_v1

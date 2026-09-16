#!/usr/bin/env python3

from backfill_config import (
    ACCOUNTS_BACKEND_START_DATE,
    ACCOUNTS_BACKEND_END_DATE,
    BACKFILL_PROJECT,
    RELAY_BACKEND_START_DATE,
    RELAY_BACKEND_END_DATE,
    SUBSCRIPTION_PLATFORM_BACKEND_START_DATE,
    SUBSCRIPTION_PLATFORM_BACKEND_END_DATE,
    SYNCSTORAGE_START_DATE,
    SYNCSTORAGE_END_DATE,
)
from copy_date_partitions import copy_date_partitions


copy_date_partitions(
    f"{BACKFILL_PROJECT}:subscription_platform_backend_stable.events_v1",
    "moz-fx-data-shared-prod:subscription_platform_backend_stable.events_v1",
    SUBSCRIPTION_PLATFORM_BACKEND_START_DATE,
    SUBSCRIPTION_PLATFORM_BACKEND_END_DATE
)

# Don't copy the `relay_backend_stable.events_v1` partitions after all because that would resurrect rows recently deleted by shredder.
#copy_date_partitions(
#    f"{BACKFILL_PROJECT}:relay_backend_stable.events_v1",
#    "moz-fx-data-shared-prod:relay_backend_stable.events_v1",
#    RELAY_BACKEND_START_DATE,
#    RELAY_BACKEND_END_DATE
#)

copy_date_partitions(
    f"{BACKFILL_PROJECT}:syncstorage_stable.events_v1",
    "moz-fx-data-shared-prod:syncstorage_stable.events_v1",
    SYNCSTORAGE_START_DATE,
    SYNCSTORAGE_END_DATE
)

copy_date_partitions(
    f"{BACKFILL_PROJECT}:accounts_backend_stable.events_v1",
    "moz-fx-data-shared-prod:accounts_backend_stable.events_v1",
    ACCOUNTS_BACKEND_START_DATE,
    ACCOUNTS_BACKEND_END_DATE
)

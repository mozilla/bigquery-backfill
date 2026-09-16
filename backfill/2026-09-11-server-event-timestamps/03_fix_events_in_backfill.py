#!/usr/bin/env python3

from datetime import timedelta

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
from fix_events import fix_events


# subscription_platform_backend has very few events, so just do the update as a single query.
fix_events(
    f"{BACKFILL_PROJECT}.subscription_platform_backend_stable.events_v1",
    SUBSCRIPTION_PLATFORM_BACKEND_START_DATE,
    SUBSCRIPTION_PLATFORM_BACKEND_END_DATE
)

# relay_backend has few events, so just do the update as a single query.
fix_events(
    f"{BACKFILL_PROJECT}.relay_backend_stable.events_v1",
    RELAY_BACKEND_START_DATE,
    RELAY_BACKEND_END_DATE
)

# syncstorage has a lot of events, so do per-month updates.
month_date = SYNCSTORAGE_START_DATE.replace(day=1)
next_month_date = (month_date + timedelta(days=31)).replace(day=1)
while month_date <= SYNCSTORAGE_END_DATE:
    fix_events(
        f"{BACKFILL_PROJECT}.syncstorage_stable.events_v1",
        max(month_date, SYNCSTORAGE_START_DATE),
        min((next_month_date - timedelta(days=1)), SYNCSTORAGE_END_DATE)
    )
    month_date = next_month_date
    next_month_date = (month_date + timedelta(days=31)).replace(day=1)

# accounts_backend has a ton of events, so do per-month updates.
month_date = ACCOUNTS_BACKEND_START_DATE.replace(day=1)
next_month_date = (month_date + timedelta(days=31)).replace(day=1)
while month_date <= ACCOUNTS_BACKEND_END_DATE:
    fix_events(
        f"{BACKFILL_PROJECT}.accounts_backend_stable.events_v1",
        max(month_date, ACCOUNTS_BACKEND_START_DATE),
        min((next_month_date - timedelta(days=1)), ACCOUNTS_BACKEND_END_DATE)
    )
    month_date = next_month_date
    next_month_date = (month_date + timedelta(days=31)).replace(day=1)

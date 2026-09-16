#!/usr/bin/env python3

from backfill_config import RELAY_BACKEND_START_DATE, RELAY_BACKEND_END_DATE
from fix_events import fix_events


# Fix relay_backend events directly in production to avoid resurrecting rows recently deleted by shredder.
# Since it has few events, we can just do the update as a single query.
fix_events(
    "moz-fx-data-shared-prod.relay_backend_stable.events_v1",
    RELAY_BACKEND_START_DATE,
    RELAY_BACKEND_END_DATE
)

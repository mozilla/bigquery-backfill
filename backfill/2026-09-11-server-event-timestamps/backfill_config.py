from datetime import date, timedelta

BACKFILL_PROJECT = "moz-fx-data-backfill-1"

ACCOUNTS_BACKEND_START_DATE = date.today() - timedelta(days=760)  # 760 day partition retention
ACCOUNTS_BACKEND_END_DATE = date(2026, 5, 13)  # https://mozilla-hub.atlassian.net/browse/FXA-13435

RELAY_BACKEND_START_DATE = date.today() - timedelta(days=400)  # 400 day partition retention
RELAY_BACKEND_END_DATE = date(2026, 3, 17)  # https://github.com/mozilla/fx-private-relay/pull/6357

SUBSCRIPTION_PLATFORM_BACKEND_START_DATE = date(2025, 6, 13)  # 760 day partition retention, but it hasn't hit that limit
SUBSCRIPTION_PLATFORM_BACKEND_END_DATE = date(2026, 5, 13)  # https://mozilla-hub.atlassian.net/browse/FXA-13435

SYNCSTORAGE_START_DATE = date.today() - timedelta(days=400)  # 400 day partition retention
SYNCSTORAGE_END_DATE = date(2026, 5, 5)  # https://mozilla-hub.atlassian.net/browse/STOR-533

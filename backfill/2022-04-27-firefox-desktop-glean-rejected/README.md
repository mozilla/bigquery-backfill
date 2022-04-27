# Backfill rejected firefox-desktop glean pings

Context:

- [tracking bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1766424)
- [incident doc](https://docs.google.com/document/d/1QX13O-ivVRlZLUm7uAYSxE7UQLBoG4VSd-4ixx8yjgg/edit#)
- [gcp-ingestion pipeline change](https://github.com/mozilla/gcp-ingestion/pull/2064)

We started rejecting all `firefox-desktop` glean pings from nightly versions of
desktop Firefox that had upgraded to a version of Glean that no longer sent a
custom `User-Agent` header. The `MessageScrubber` filter that was causing those
to be dropped was changed on 2022-04-27 and we have confirmed that pings are now
correctly flowing.

The purpose of this backfill is to get the rejected pings from the affected period
integrated into stable tables and downstream derived tables.

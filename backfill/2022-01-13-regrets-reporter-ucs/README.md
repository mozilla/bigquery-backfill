# Backfill rejected events from RegretsReporter extension between 2021-11-17 and 2022-01-09

  - [Bug 1748284](https://bugzilla.mozilla.org/show_bug.cgi?id=1748284): Schema validation errors for timestamps in regrets-reporter-ucs main-events pings


## Context

  - [Glean.js v0.17.0](https://github.com/mozilla/glean.js/releases/tag/v0.17.0) was released on 2021-07-16 with a [change](https://github.com/mozilla/glean.js/commit/3ea07fc885a83f825d553040c91f12eb2fd63837#diff-952bad66acb1e3eeaf5fb239a29962bf4d4b7abe8e3343dd4245dbd6d818c04cR174) that caused event timestamps to have floating point values when [`performance.now()`](https://developer.mozilla.org/en-US/docs/Web/API/Performance/now) is available.
  - [RegretsReporter v2.0.3](https://github.com/mozilla-extensions/regrets-reporter/releases/tag/v2.0.3) was released on 2021-12-03 [using Glean.js v0.27.0](https://github.com/mozilla-extensions/regrets-reporter/blob/v2.0.3/package.json#L33).
  - On 2021-12-03 tens of thousands of RegretsReporter event payloads began to be rejected every day by the ingestion pipeline during [payload parsing](https://github.com/mozilla/gcp-ingestion/blob/e6783df9140fcfcb8c9bf805860f9d3796398dc6/ingestion-beam/src/main/java/com/mozilla/telemetry/decoder/ParsePayload.java#L164) due to the contained events having non-integer timestamp values, when the Glean schema requires the event timestamp values to be integers.
    - Example error message: `org.everit.json.schema.ValidationException: #/events/1/timestamp: expected type: Integer, found: Double`
    - A smaller number of such RegretsReporter event payloads were rejected between 2021-11-17 and 2021-12-02, likely from testing RegretsReporter v2 prior to release.
  - [Glean.js v0.29.0](https://github.com/mozilla/glean.js/releases/tag/v0.29.0) was released on 2022-01-04 with a [fix](https://github.com/mozilla/glean.js/commit/d9a005f1902b08c38187c190181490c477ad5ff4#diff-952bad66acb1e3eeaf5fb239a29962bf4d4b7abe8e3343dd4245dbd6d818c04cR191) to make all event timestamps have integer values.
  - [RegretsReporter v2.0.5](https://github.com/mozilla-extensions/regrets-reporter/releases/tag/v2.0.5) was released on 2022-01-04 which [upgraded its Glean.js to v0.29.0](https://github.com/mozilla-extensions/regrets-reporter/compare/v2.0.4...v2.0.5#diff-7ae45ad102eab3b6d7e7896acd08c427a9b25b346470d7bc6507b6481575d519R33).
  - On 2022-01-07 the number of such RegretsReporter event payloads being rejected dropped to less than ten thousand per day.
  - As of 2022-01-14 there continue to be hundreds of such RegretsReporter event payloads being rejected per day, but that volume is low enough to not be a serious concern.

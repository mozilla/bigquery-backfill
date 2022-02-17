CREATE TEMP FUNCTION sanitize_labeled_counter(input ARRAY<STRUCT<key STRING, value INT64>>) AS (
  ARRAY(
    WITH base AS (
      SELECT
        *,
        REGEXP_EXTRACT(key, r"([^.]+[.]in-content[.][^.]+[.])[^.]*[.]?.*") AS prefix,
        REGEXP_EXTRACT(key, r"[^.]+[.]in-content[.][^.]+[.]([^.]*)[.]?.*") AS code,
        REGEXP_EXTRACT(key, r"[^.]+[.]in-content[.][^.]+[.][^.]*[.]?(.*)") AS channel,
      FROM
        UNNEST(input)
    ),
    validations AS (
      SELECT
        *,
        code IN (
          "none",
          "other",
          "hz",
          "h_",
          "moz2",
          "moz4",
          "moz5",
          "moza",
          "mozb",
          "mozd",
          "moze",
          "mozi",
          "mozm",
          "mozo",
          "mozt",
          "mozw",
          "mozsl01",
          "mozsl02",
          "mozsl03",
          "firefox-a",
          "firefox-b",
          "firefox-b-1",
          "firefox-b-ab",
          "firefox-b-1-ab",
          "firefox-b-d",
          "firefox-b-1-d",
          "firefox-b-e",
          "firefox-b-1-e",
          "firefox-b-m",
          "firefox-b-1-m",
          "firefox-b-o",
          "firefox-b-1-o",
          "firefox-b-lm",
          "firefox-b-1-lm",
          "firefox-b-lg",
          "firefox-b-huawei-h1611",
          "firefox-b-is-oem1",
          "firefox-b-oem1",
          "firefox-b-oem2",
          "firefox-b-tinno",
          "firefox-b-pn-wt",
          "firefox-b-pn-wt-us",
          "ubuntu",
          "ffab",
          "ffcm",
          "ffhp",
          "ffip",
          "ffit",
          "ffnt",
          "ffocus",
          "ffos",
          "ffsb",
          "fpas",
          "fpsa",
          "ftas",
          "ftsa",
          "newext",
          "monline_dg",
          "monline_3_dg",
          "monline_4_dg",
          "monline_7_dg",
          "_1000969a",
          "_1000969b"
        ) AS code_is_valid,
        channel IS NULL
        OR channel = ""
        OR channel = "ts" AS channel_is_valid,
      FROM
        base
    ),
    -- This logic should match https://github.com/mozilla/gcp-ingestion/blob/b88da84c017ee6251947b5223019bee90d20ea3b/ingestion-beam/src/main/java/com/mozilla/telemetry/decoder/MessageScrubber.java#L456-L489
    scrubbed AS (
      SELECT
        * REPLACE (
          CASE
          -- If prefix is null, this didn't match the regex and we want to pass through unchanged
          WHEN
            prefix IS NULL
          THEN
            key
          WHEN
            code_is_valid
            AND channel_is_valid
          THEN
            key
          WHEN
            code_is_valid
            AND NOT channel_is_valid
          THEN
            FORMAT("%s%s", prefix, code)
          ELSE
            FORMAT("%s%s", prefix, "other-scrubbed")
          END
          AS key
        )
      FROM
        validations
    )
    SELECT AS STRUCT
      key,
      SUM(value) AS value
    FROM
      scrubbed
    GROUP BY
      key
  )
);

CREATE TABLE
  `moz-fx-data-backfill-20.org_mozilla_fenix_stable.metrics_v1` LIKE `moz-fx-data-shared-prod.org_mozilla_fenix_stable.metrics_v1`
AS
SELECT
  * REPLACE (
    (
      SELECT AS STRUCT
        metrics.* REPLACE (
          (
            SELECT AS STRUCT
              metrics.labeled_counter.* REPLACE (
                sanitize_labeled_counter(
                  metrics.labeled_counter.browser_search_ad_clicks
                ) AS browser_search_ad_clicks,
                sanitize_labeled_counter(
                  metrics.labeled_counter.browser_search_in_content
                ) AS browser_search_in_content
              )
          ) AS labeled_counter
        )
    ) AS metrics
  )
FROM
  `moz-fx-data-shared-prod.org_mozilla_fenix_stable.metrics_v1`
WHERE
   -- all time
  DATE(submission_timestamp) >= "2010-01-01"

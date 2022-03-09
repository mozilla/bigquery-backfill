CREATE TEMP FUNCTION sanitize_search_counts(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^.]+\\.in-content[:.][^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^.]+\\.in-content[:.][^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      --key AS old_key,
      value))
  FROM base
));

CREATE TEMP FUNCTION sanitize_scalar(input ANY TYPE) AS ((
  WITH base AS (
    SELECT
      key,
      value,
      REGEXP_EXTRACT(key, "([^:]+:[^:]+:).*") AS prefix,
      REGEXP_EXTRACT(key, "[^:]+:[^:]+:(.*)") AS code,
      FROM UNNEST(input)
  )
  SELECT ARRAY_AGG(STRUCT(
    IF(prefix IS NULL OR code IN ("none", "other", "hz", "h_", "MOZ2", "MOZ4", "MOZ5", "MOZA", "MOZB", "MOZD", "MOZE", "MOZI", "MOZM", "MOZO", "MOZT", "MOZW", "MOZSL01", "MOZSL02", "MOZSL03", "firefox-a", "firefox-b", "firefox-b-1", "firefox-b-ab", "firefox-b-1-ab", "firefox-b-d", "firefox-b-1-d", "firefox-b-e", "firefox-b-1-e", "firefox-b-m", "firefox-b-1-m", "firefox-b-o", "firefox-b-1-o", "firefox-b-lm", "firefox-b-1-lm", "firefox-b-lg", "firefox-b-huawei-h1611", "firefox-b-is-oem1", "firefox-b-oem1", "firefox-b-oem2", "firefox-b-tinno", "firefox-b-pn-wt", "firefox-b-pn-wt-us", "ubuntu", "ffab", "ffcm", "ffhp", "ffip", "ffit", "ffnt", "ffocus", "ffos", "ffsb", "fpas", "fpsa", "ftas", "ftsa", "newext", "monline_dg", "monline_3_dg", "monline_4_dg", "monline_7_dg"),
      key,
      CONCAT(prefix, "other.scrubbed")) AS key,
      --key AS old_key,
      value))
  FROM base
));

WITH
unioned AS (
 SELECT
  *
 FROM
  --`moz-fx-data-shared-prod.telemetry_live.main_v4`
  `moz-fx-data-shared-prod.telemetry.main_1pct`
 WHERE
  submission_timestamp BETWEEN "2022-01-10 12:00:00 UTC" AND "2022-01-10 12:10:00 UTC"
),
base AS (
 SELECT
 payload.keyed_histograms.* REPLACE(sanitize_search_counts(payload.keyed_histograms.search_counts) AS search_counts),
 payload.processes.parent.keyed_scalars.* REPLACE(sanitize_scalar(payload.processes.parent.keyed_scalars.browser_search_content_urlbar) AS browser_search_content_urlbar),
/*
      payload.processes.parent.keyed_scalars.browser_search_content_urlbar_handoff,
      payload.processes.parent.keyed_scalars.browser_search_content_urlbar_searchmode,
      payload.processes.parent.keyed_scalars.browser_search_content_searchbar,
      payload.processes.parent.keyed_scalars.browser_search_content_about_home,
      payload.processes.parent.keyed_scalars.browser_search_content_about_newtab,
      payload.processes.parent.keyed_scalars.browser_search_content_contextmenu,
      payload.processes.parent.keyed_scalars.browser_search_content_webextension,
      payload.processes.parent.keyed_scalars.browser_search_content_system,
      payload.processes.parent.keyed_scalars.browser_search_content_tabhistory,
      payload.processes.parent.keyed_scalars.browser_search_content_reload,
      payload.processes.parent.keyed_scalars.browser_search_content_unknown
      payload.processes.parent.keyed_scalars.browser_search_content_searchbar */
FROM
  unioned
--WHERE normalized_channel = 'nightly'
)
SELECT browser_search_content_urlbar FROM base
where ARRAY_LENGTH(browser_search_content_urlbar) > 0
--AND to_json_string(browser_search_content_urlbar) like '%scrubbed%'
limit 100

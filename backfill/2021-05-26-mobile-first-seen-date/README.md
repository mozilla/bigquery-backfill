# Backfill `first_seen_date` for core tables

See https://github.com/mozilla/bigquery-etl/issues/2056

One-off query to stage a table update first_seen_date and is_new_profile
to core_clients_daily (`mozdata:US.bquxjob_70bb897e_179a9ed9330`, ~15m):

```sql
CREATE OR REPLACE TABLE
  mozdata.tmp.amiyaguchi_core_cd_with_first_seen
PARTITION BY
  submission_date
CLUSTER BY
  is_new_profile,
  app_name,
  os AS
SELECT
  cd.* except (first_seen_date, is_new_profile),
  cfs.first_seen_date,
  (cfs.first_seen_date = cd.submission_date) AS is_new_profile,
FROM
  `moz-fx-data-shared-prod.telemetry_derived.core_clients_daily_v1` AS cd
LEFT JOIN
  `moz-fx-data-shared-prod.telemetry_derived.core_clients_first_seen_v1` AS cfs
USING
  (client_id)
WHERE
  submission_date >= "2010-01-01"
```

One-off query to stage a table adding first_seen_date to core_clients_last_seen
(`mozdata:US.bquxjob_2f22ec1f_179aa02c7c7`, ~35m):

```sql
CREATE OR REPLACE TABLE
  mozdata.tmp.amiyaguchi_core_cls_with_first_seen
PARTITION BY
  submission_date
CLUSTER BY
  app_name,
  os AS
SELECT
  cls.* except (first_seen_date),
  cfs.first_seen_date
FROM
  `moz-fx-data-shared-prod.telemetry_derived.core_clients_last_seen_v1` AS cls
LEFT JOIN
  `moz-fx-data-shared-prod.telemetry_derived.core_clients_first_seen_v1` AS cfs
USING
  (client_id)
WHERE
  submission_date >= "2010-01-01"
```

Then, we can use the staged `amiyaguchi_core_cls_with_first_seen` to create a
table of just `new_profiles` aggregates that we'll later join with the existing
`firefox_nondesktop_exact_mau` data. The query here copies in the definition of
`nondesktop_clients_last_seen`, but references our staging table for `core`
pings (`mozdata:US.bquxjob_4b42bad8_179aa267df5`, ~3m):

```sql
CREATE OR REPLACE TABLE
  mozdata.tmp.amiyaguchi_nondesktop_new_profiles
PARTITION BY
  submission_date
AS
WITH glean_final AS (
  SELECT
    *
  FROM
    `moz-fx-data-shared-prod.telemetry.fenix_clients_last_seen`
  UNION ALL
  SELECT
    *,
    'Lockwise Baseline' AS app_name,
  FROM
    `moz-fx-data-shared-prod.mozilla_lockbox.baseline_clients_last_seen`
  UNION ALL
  SELECT
    *,
    'Lockwise Baseline' AS app_name,
  FROM
    `moz-fx-data-shared-prod.org_mozilla_ios_lockbox.baseline_clients_last_seen`
  UNION ALL
  SELECT
    *,
    'Reference Browser Baseline' AS app_name,
  FROM
    `moz-fx-data-shared-prod.org_mozilla_reference_browser.baseline_clients_last_seen`
  UNION ALL
  SELECT
    *,
    'Firefox TV Baseline' AS app_name,
  FROM
    `moz-fx-data-shared-prod.org_mozilla_tv_firefox.baseline_clients_last_seen`
  UNION ALL
  SELECT
    *,
    'VR Browser Baseline' AS app_name,
  FROM
    `moz-fx-data-shared-prod.org_mozilla_vrbrowser.baseline_clients_last_seen`
),
unioned AS (
  SELECT
    submission_date,
    client_id,
    first_seen_date,
    days_seen_bits,
    --days_since_seen,
    days_created_profile_bits,
    --days_since_created_profile,
    app_name,
    os,
    osversion AS os_version,
    normalized_channel,
    campaign,
    country,
    locale,
    distribution_id,
    metadata_app_version AS app_version,
    mozfun.norm.product_info(app_name, os) AS pinfo,
  FROM
    -- We use our temp table here
    mozdata.tmp.amiyaguchi_core_cls_with_first_seen
  UNION ALL
  SELECT
    submission_date,
    client_id,
    first_seen_date,
    days_seen_bits,
    --days_since_seen,
    days_created_profile_bits,
    --days_since_created_profile,
    app_name,
    normalized_os AS os,
    normalized_os_version AS os_version,
    normalized_channel,
    NULL AS campaign,
    country,
    locale,
    NULL AS distribution_id,
    app_display_version AS app_version,
    mozfun.norm.product_info(app_name, normalized_os) AS pinfo,
  FROM
    glean_final
),
ncls AS (
SELECT
  * EXCEPT (pinfo),
  pinfo.product,
  pinfo.canonical_name,
  pinfo.contributes_to_2019_kpi,
  pinfo.contributes_to_2020_kpi,
  pinfo.contributes_to_2021_kpi
FROM
  unioned
)
SELECT
  submission_date,
  COUNTIF(first_seen_date = submission_date) AS new_profiles,
  -- We hash client_ids into 20 buckets to aid in computing
  -- confidence intervals for mau/wau/dau sums; the particular hash
  -- function and number of buckets is subject to change in the future.
  MOD(ABS(FARM_FINGERPRINT(client_id)), 20) AS id_bucket,
  -- Instead of app_name and os, we provide a single clean "product" name
  -- that includes OS where necessary to disambiguate.
  product,
  normalized_channel,
  campaign,
  country,
  distribution_id
FROM
  ncls
WHERE
  contributes_to_2020_kpi
  -- 2017-01-01 is the first populated day of telemetry_core_parquet, so start 28 days later.
  AND submission_date >= DATE '2017-01-28'
GROUP BY
  submission_date,
  id_bucket,
  product,
  normalized_channel,
  campaign,
  country,
  distribution_id
```

We then join this with the existing exact_mau28 table. Note that because some of
the dimension values can be NULL, we can't use them directly in a join.
Instead, we create a hash of the JSON representation of the values as
a stable joinkey (`mozdata:US.bquxjob_19322cf4_179aa2bb35e`):

```sql
CREATE OR REPLACE TABLE
  mozdata.tmp.amiyaguchi_nondesktop_exact_mau
PARTITION BY
  submission_date
AS
WITH base AS (
SELECT 
  * except (new_profiles),
  FARM_FINGERPRINT(TO_JSON_STRING(STRUCT(submission_date,
  id_bucket,
  product,
  normalized_channel,
  campaign,
  country,
  distribution_id))) AS joinkey
FROM
  `moz-fx-data-shared-prod.telemetry_derived.firefox_nondesktop_exact_mau28_v1`
),
np AS (
SELECT 
  *,
  FARM_FINGERPRINT(TO_JSON_STRING(STRUCT(submission_date,
  id_bucket,
  product,
  normalized_channel,
  campaign,
  country,
  distribution_id))) AS joinkey
FROM
  mozdata.tmp.amiyaguchi_nondesktop_new_profiles AS np
)
SELECT 
  base.* EXCEPT (joinkey),
  np.new_profiles
FROM 
  base
LEFT JOIN
  np
USING (joinkey)
```

And finally stage the mobile_usage table (`mozdata:US.bquxjob_2518a474_179aa2e113a`):

```sql
CREATE OR REPLACE TABLE
  mozdata.tmp.amiyaguchi_mobile_usage_with_new_profiles
PARTITION BY
  submission_date
AS
WITH base AS (
  SELECT
    *,
    EXTRACT(YEAR FROM submission_date) AS submission_year,
  FROM
    mozdata.tmp.amiyaguchi_nondesktop_exact_mau
  WHERE
    -- We completely recreate this table every night since the source table
    -- is small and this query windows over a large time range.
    submission_date >= '2017-01-01'
),
--
-- We need a continuous list of dates to aid us later in transforming into
-- a dense representation where each slice appears every day.
continuous_dates AS (
  SELECT
    submission_date,
    EXTRACT(YEAR FROM submission_date) AS submission_year
  FROM
    UNNEST(
      GENERATE_DATE_ARRAY(
        (SELECT MIN(submission_date) FROM base),
        (SELECT MAX(submission_date) FROM base)
      )
    ) AS submission_date
),
--
-- We aggregate all the counts for a given slice into an array per year,
-- so that we can operate on entire years of data consistently.
nested_counts_by_slice_year_sparse AS (
  SELECT
    submission_year,
    id_bucket,
    product,
    normalized_channel,
    campaign,
    country,
    distribution_id,
    ARRAY_AGG(STRUCT(submission_date, dau, wau, mau, new_profiles)) AS counts_array,
  FROM
    base
  GROUP BY
    submission_year,
    id_bucket,
    product,
    normalized_channel,
    campaign,
    country,
    distribution_id
),
--
-- Now we fill out the array of counts, injecting empty values for any days on which
-- a given slice does not appear.
nested_counts_by_slice_year_dense AS (
  SELECT
    * REPLACE (
      ARRAY(
        SELECT
          STRUCT(submission_date, c.dau, c.mau, c.wau, c.new_profiles)
        FROM
          UNNEST(counts_array) AS c
        FULL JOIN
          -- This is a "correlated subquery" that references a field from the
          -- outer query in order to filter to just the relevant year.
          (
            SELECT
              submission_date
            FROM
              continuous_dates
            WHERE
              submission_year = nested_counts_by_slice_year_sparse.submission_year
          )
        USING
          (submission_date)
      ) AS counts_array
    )
  FROM
    nested_counts_by_slice_year_sparse
),
--
-- We can now explode the array, leading to a flat representation which now includes
-- one row per day per slice, regardless of whether any clients were seen for that
-- slice on that particular day.
exploded AS (
  SELECT
    c.*,
    nested_counts_by_slice_year_dense.* EXCEPT (counts_array)
  FROM
    nested_counts_by_slice_year_dense,
    UNNEST(counts_array) AS c
)
--
-- Finally, we can do our windowed SUM to materialize CDOU.
SELECT
  SUM(dau) OVER year_slice AS cdou,
  SUM(new_profiles) OVER (year_slice) AS cumulative_new_profiles,
  *
FROM
  exploded
WINDOW
  year_slice AS (
    PARTITION BY
      submission_year,
      id_bucket,
      product,
      normalized_channel,
      campaign,
      country,
      distribution_id
    ORDER BY
      submission_date
  )
```

All these queries ran correctly, and the row counts match with the original tables.

```bash
function nrows { bq show --format json $1 | jq -r '.numRows' }
function diff { echo $(( $(nrows $1) - $(nrows $2) )) }
diff mozdata:tmp.amiyaguchi_core_cd_with_first_seen moz-fx-data-shared-prod:telemetry_derived.core_clients_daily_v1
diff mozdata:tmp.amiyaguchi_core_cls_with_first_seen moz-fx-data-shared-prod:telemetry_derived.core_clients_last_seen_v1
diff mozdata:tmp.amiyaguchi_nondesktop_exact_mau moz-fx-data-shared-prod:telemetry_derived.firefox_nondesktop_exact_mau28_v1
diff mozdata:tmp.amiyaguchi_mobile_usage_with_new_profiles moz-fx-data-shared-prod:telemetry_derived.mobile_usage_v1
```

We move them into place:

```bash
bq cp -f mozdata:tmp.amiyaguchi_core_cd_with_first_seen moz-fx-data-shared-prod:telemetry_derived.core_clients_daily_v1
bq cp -f mozdata:tmp.amiyaguchi_core_cls_with_first_seen moz-fx-data-shared-prod:telemetry_derived.core_clients_last_seen_v1
bq cp -f mozdata:tmp.amiyaguchi_nondesktop_exact_mau moz-fx-data-shared-prod:telemetry_derived.firefox_nondesktop_exact_mau28_v1
bq cp -f mozdata:tmp.amiyaguchi_mobile_usage_with_new_profiles moz-fx-data-shared-prod:telemetry_derived.mobile_usage_v1
```

And we republish views:

```bash
./script/publish_views --target-project=moz-fx-data-shared-prod sql/moz-fx-data-shared-prod/telemetry/ --user-facing-only
./script/publish_views --target-project=mozdata sql/moz-fx-data-shared-prod/telemetry/ --user-facing-only
```
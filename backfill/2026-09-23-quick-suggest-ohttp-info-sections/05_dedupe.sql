-- Dedupe recovered pings and drop any already present in prod.
--
-- Per day rather than across the whole window, matching copy_deduplicate semantics.
--
-- The prod lookup uses a constant timestamp range, not a correlated
-- DATE(p.submission_timestamp) = DATE(n.submission_timestamp) predicate. Prod stable has
-- require_partition_filter set, and a correlated predicate cannot be used for partition
-- elimination, so the correlated form fails with
--   Cannot query over table ... without a filter over column(s) 'submission_timestamp'
--
-- Partitioning and clustering are stated explicitly to match prod stable, since
-- CREATE OR REPLACE does not inherit them.
--
-- Run one statement at a time.

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.firefox_desktop__quick_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.firefox_desktop_stable.quick_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__quick_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.firefox_desktop__urlbar_keyword_exposure_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.firefox_desktop_stable.urlbar_keyword_exposure_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.firefox_desktop__urlbar_keyword_exposure_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox__fx_suggest_api_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_stable.fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox__fx_suggest_api_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_firefox_beta__fx_suggest_api_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_firefox_beta__fx_suggest_api_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix__fx_suggest_api_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_stable.fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix__fx_suggest_api_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_fenix_nightly__fx_suggest_api_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_fenix_nightly_stable.fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fenix_nightly__fx_suggest_api_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_fennec_aurora__fx_suggest_api_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_fennec_aurora_stable.fx_suggest_api_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_fennec_aurora__fx_suggest_api_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefox__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_ios_firefox_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefox__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_ios_firefoxbeta_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_firefoxbeta__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );

CREATE OR REPLACE TABLE `BACKFILL_PROJECT.staging_stable.org_mozilla_ios_fennec__fx_suggest_v1`
PARTITION BY DATE(submission_timestamp)
CLUSTER BY normalized_channel, sample_id
AS
WITH existing AS (
  SELECT document_id, DATE(submission_timestamp) AS dt
  FROM `moz-fx-data-shared-prod.org_mozilla_ios_fennec_stable.fx_suggest_v1`
  WHERE submission_timestamp >= TIMESTAMP('2026-09-22')
    AND submission_timestamp <  TIMESTAMP('2026-09-24')
),
numbered AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY DATE(submission_timestamp), document_id
    ORDER BY submission_timestamp
  ) AS _rn
  FROM `BACKFILL_PROJECT.staging_live.org_mozilla_ios_fennec__fx_suggest_v1`
)
SELECT * EXCEPT (_rn)
FROM numbered AS n
WHERE _rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM existing AS e
    WHERE e.document_id = n.document_id
      AND e.dt = DATE(n.submission_timestamp)
  );


# Running errors through Decoder for geo IP info

See https://bugzilla.mozilla.org/show_bug.cgi?id=1613225

## Steps

We ran the backfill in the `moz-fx-data-backfill-5` project. 

We deployed the change on 2020-02-07 that made sure new errors have geo IP
lookup already performed such that IP addresses are no longer flowing into
errors tables. We want to backfill everything from `2020-02-07` and
earlier.

We create destination tables via the `mirror-prod-tables` script using a
modified `error.bq.json** schema with all IP fields removed.

**Note**: We modified the ingestion-beam codebase for this task 
to reduce the Decoder job down to only the `ParseProxy` and `GeoIPLookup`
transforms. We didn't want to accidentally introduce any other errors by
running the other steps.

Next, we construct a suitable Dataflow job configuration in
`launch-dataflow-error-geo` and run the script. We did a test run first on
a single day; once that was successful, we purged the tables of data
and ran the full backfill.

We visit the GCP console, choose the `moz-fx-data-backfill-5` project
and go to the Dataflow section to watch the progress of the job.
It took about 42 minutes to run to completion.

We validate the results by checking counts per day:

```sql
SELECT
  DATE(submission_timestamp),
  _TABLE_SUFFIX AS tbl,
  COUNT(*) AS n,
  COUNT(geo_country) AS country,
  COUNT(x_forwarded_for) AS xff,
  COUNT(remote_addr) AS remote_addr,
  COUNT(x_pipeline_proxy) AS x_pipeline_proxy,
FROM
  `moz-fx-data-backfill-5.payload_bytes_error.*`
GROUP BY
  1, 2
ORDER BY
  1, 2
```

The IP fields are all null now and the vast majority have non-null country
(we expect some small number of pings to fail geo lookup), so we've done
our job here.

Now, we overwrite the relevant partitions data to the production tables:

```bash
for family in stub_installer telemetry structured; do
  seq 0 170 \
      | xargs -I@ gdate -d '2019-08-21 + @ day' +%F \
      | xargs -P10 -n1 bash -c 'set -ex; bq cp -f moz-fx-data-backfill-5:payload_bytes_error.'$family'\$${1//-} moz-fx-data-shared-prod:payload_bytes_error.'$family'\$${1//-}' -s
done
```

Finally, we clean up all resources in the backfill project:

```
# BE CAREFUL! This removes all BQ datasets and GCS buckets from the target projects, 
# including their contents; it cannot be undone.
for x in 5; do 
    echo $x; 
    bq ls --project_id=moz-fx-data-backfill-$x | tail -n+3 | awk '{print $1}' | xargs -I{} -n1 echo bq rm -r -f "moz-fx-data-backfill-${x}:{}"
    gsutil ls -p moz-fx-data-backfill-$x | xargs echo gsutil -m rm -r
done
```

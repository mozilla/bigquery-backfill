# Backfill GCS error records to BQ stable tables

See [bug 1625560](https://bugzilla.mozilla.org/show_bug.cgi?id=1625560) for more context.

This backfills the structured ingestion tables from 2020-02-18 through
2020-03-14. Telemetry is backfilled from 2020-02-19 through 2020-03-12.

## Action items and notes

* Generate listing of telemetry and structured errors
* Appropriate `moz-fx-data-backfill-30` for backfill
* Copy data into `gs://bug-1625560-backfill` via `copy-data.sh`
* Create mirrored tables via `mirror-prod-tables.sh`
* Run dataflow jobs for backfill into stable-like tables via
  `launch-dataflow-job.sh`. See [1].
* Debug failures on telemetry backfills
  * Telemetry: Unpaired surrogate at index 853 [2]
  * Structured: Error during BigQuery IO [3]
* Run dataflow jobs for a single date (Friday, 2020-02-21)
  * Structured succeeds in 26 min 33 sec scaling up to 125 nodes
  * Telemetry succeeds in 39 min 3 sec scaling up to 232 nodes
* Run modified dataflow job script for 2020-02-18 through 2020-02-20
  * Max workers set to 150 based on above behavior
* Run modified dataflow job script for all affected date ranges [4]
* Manually verify all dates have been run
  * Compare `listing_backfill_input.txt` with `listing_backfill_jobs.txt`
  * Job listing was missing telemetry 2020-02-23, reran this particular date
* Appropriate `moz-fx-data-backfill-31` for staging of data
  * Create mirrored tables
* Verify dedupe script
  * `DEBUG=true ./stage_deduplicated.sh` and check within bq console
  * Based on a dry run, the job is expected to scan 1.42362 TB
* Run deduplication into `moz-fx-data-backfill-31`
  * Runtime of 37 minutes
* Run `validation.sh` to check table counts before and after de-duplication
  * Copy `validation.table_counts` into `moz-fx-data-shared-prod:analysis.bug1625560_table_counts`
  * It is difficult to decouple dupes from within errors vs dupes within
    production tables, but overall the de-deuplication rate is low enough (0.1%)
    across all documents to conclude that these documents are indeed missing.
    There are a total of 64M rows that are added to the production tables across
    10 days. [5]

[1] Running `launch-dataflow-job.sh`:

```bash
# assume gcp-ingestion and bigquery-backfill share the same parent
cd gcp-ingestion/ingestion-beam
../../bigquery-backfill/backfill/2020-03-30-gcs-error/launch-dataflow-job.sh (structured|telemetry) [DATE_DS]
```

[2] In the first 20 minutes of processing Telemetry pings, the following error
caused the job to fail.

```bash
2020-03-30 16:15:37.000 PDT
Error message from worker: java.lang.IllegalArgumentException: Unpaired surrogate at index 858
org.apache.beam.vendor.guava.v26_0_jre.com.google.common.base.Utf8.encodedLengthGeneral(Utf8.java:93)
org.apache.beam.vendor.guava.v26_0_jre.com.google.common.base.Utf8.encodedLength(Utf8.java:67)
org.apache.beam.sdk.coders.StringUtf8Coder.getEncodedElementByteSize(StringUtf8Coder.java:138)
org.apache.beam.sdk.io.gcp.bigquery.TableRowJsonCoder.getEncodedElementByteSize(TableRowJsonCoder.java:63)
org.apache.beam.sdk.io.gcp.bigquery.TableRowJsonCoder.getEncodedElementByteSize(TableRowJsonCoder.java:32)
org.apache.beam.sdk.coders.Coder.registerByteSizeObserver(Coder.java:291)
org.apache.beam.sdk.coders.KvCoder.registerByteSizeObserver(KvCoder.java:128)
org.apache.beam.sdk.coders.KvCoder.registerByteSizeObserver(KvCoder.java:36)
org.apache.beam.sdk.util.WindowedValue$FullWindowedValueCoder.registerByteSizeObserver(WindowedValue.java:623)
org.apache.beam.sdk.util.WindowedValue$FullWindowedValueCoder.registerByteSizeObserver(WindowedValue.java:539)
org.apache.beam.runners.dataflow.worker.IntrinsicMapTaskExecutorFactory$ElementByteSizeObservableCoder.registerByteSizeObserver(IntrinsicMapTaskExecutorFactory.java:400)
org.apache.beam.runners.dataflow.worker.util.common.worker.OutputObjectAndByteCounter.update(OutputObjectAndByteCounter.java:125)
org.apache.beam.runners.dataflow.worker.DataflowOutputCounter.update(DataflowOutputCounter.java:64)
org.apache.beam.runners.dataflow.worker.util.common.worker.OutputReceiver.process(OutputReceiver.java:43)
org.apache.beam.runners.dataflow.worker.SimpleParDoFn$1.output(SimpleParDoFn.java:280)
org.apache.beam.runners.dataflow.worker.repackaged.org.apache.beam.runners.core.SimpleDoFnRunner.outputWindowedValue(SimpleDoFnRunner.java:256)
org.apache.beam.runners.dataflow.worker.repackaged.org.apache.beam.runners.core.SimpleDoFnRunner.access$700(SimpleDoFnRunner.java:74)
org.apache.beam.runners.dataflow.worker.repackaged.org.apache.beam.runners.core.SimpleDoFnRunner$DoFnProcessContext.output(SimpleDoFnRunner.java:580)
org.apache.beam.runners.dataflow.worker.repackaged.org.apache.beam.runners.core.SimpleDoFnRunner$DoFnProcessContext.output(SimpleDoFnRunner.java:568)
org.apache.beam.sdk.io.gcp.bigquery.PrepareWrite$1.processElement(PrepareWrite.java:82)
```

[3] During the processing of Structured pings, the job failed after 12 hours and
28 minutes with an `OutOfMemoryError`:

```bash
java.util.regex.Pattern.sequence(Pattern.java:2063)
java.util.regex.Pattern.expr(Pattern.java:1996)
java.util.regex.Pattern.compile(Pattern.java:1696)
java.util.regex.Pattern.<init>(Pattern.java:1351)
java.util.regex.Pattern.compile(Pattern.java:1028)
java.util.regex.Pattern.matches(Pattern.java:1133)
java.lang.String.matches(String.java:2121)
org.apache.beam.sdk.extensions.gcp.util.gcsfs.GcsPath.<init>(GcsPath.java:186)
org.apache.beam.sdk.extensions.gcp.util.gcsfs.GcsPath.fromUri(GcsPath.java:119)
org.apache.beam.sdk.extensions.gcp.util.GcsUtil.makeRemoveBatches(GcsUtil.java:738)
```

[4] It's unknown whether the errors seen in [2] and [3] were transient or based
on the size of the input. Splitting the backfill on a per day basis allowed for
all of the jobs to complete, though.

[5]

In total:

```sql
SELECT
  sum(num_deduped) as total,
  sum(diff)/sum(num_raw)*100 as pct
FROM
  `moz-fx-data-shared-prod`.analysis.bug1625560_table_counts
```

total | pct
-|-
64016735 | 0.11772261910367669

By submission date:

```sql
SELECT
  submission_date,
  SUM(num_deduped) AS total,
  SUM(diff)/SUM(num_raw)*100 AS pct
FROM
  `moz-fx-data-shared-prod`.analysis.bug1625560_table_counts
GROUP BY
  1
ORDER BY
  1
```

submission_date | total | pct
-|-|-
2020-02-18 | 1 | 0.0
2020-02-19 | 1423198 | 0.5950198258454709
2020-02-20 | 7653097 | 0.14137651534486476
2020-02-21 | 13375280 | 0.13259873281933995
2020-02-22 | 9383805 | 0.05117903502222374
2020-02-23 | 6791811 | 0.03523591060322731
2020-02-24 | 11194373 | 0.09718647389177747
2020-02-25 | 13911544 | 0.1448851036364546
2020-02-26 | 266301 | 0.022525820221428815
2020-03-11 | 15954 | 0.018800526414739612
2020-03-12 | 1367 | 0.07309941520467836
2020-03-14 | 4 | 0.0

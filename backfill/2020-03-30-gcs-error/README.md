# Backfill GCS error records to BQ stable tables

See [bug 1625560](https://bugzilla.mozilla.org/show_bug.cgi?id=1625560) for more context.

This backfills the structured ingestion tables from 2020-02-18 through
2020-03-14. Telemetry is backfilled from 2020-02-19 through 2020-03-12.

## Action items

* Generate listing of telemetry and structured errors
* Appropriate `moz-fx-data-backfill-30` for backfill
* Copy data into `gs://bug-1625560-backfill` via `copy-data.sh`
* Create mirrored tables via `mirror-prod-tables.sh`
* Run dataflow jobs for backfill into stable-like tables via
  `launch-dataflow-job.sh`. See [1].
* Debug failures on telemetry backfills
* Run dataflow jobs for a single date

[1] Running `launch-dataflow-job.sh`:

```bash
# assume gcp-ingestion and bigquery-backfill share the same parent
    cd gcp-ingestion/ingestion-beam
    ../../bigquery-backfill/backfill/2020-03-30-gcs-error/launch-dataflow-job.sh (structured|telemetry)
```


## Issues

During the backfill, two separate issues were uncovered during the processing of the error streams.
In the first 20 minutes of processing Telemetry pings, the following error caused the job to fail.

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

During the processing of Structured pings, the job failed after 12 hours and 28 minutes with an `OutOfMemoryError`:

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

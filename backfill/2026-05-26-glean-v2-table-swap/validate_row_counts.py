from google.cloud import bigquery
PROJECT = "moz-fx-data-shared-prod"
TABLES = [
    ("org_mozilla_fennec_aurora_stable", "adjust_attribution"),
    ("org_mozilla_fennec_aurora_stable", "captcha_detection"),
    ("org_mozilla_fennec_aurora_stable", "first_session"),
    ("org_mozilla_fennec_aurora_stable", "health"),
    ("org_mozilla_fennec_aurora_stable", "metrics"),
    ("org_mozilla_fennec_aurora_stable", "sync"),
    ("org_mozilla_fenix_nightly_stable", "adjust_attribution"),
    ("org_mozilla_fenix_nightly_stable", "captcha_detection"),
    ("org_mozilla_fenix_nightly_stable", "first_session"),
    ("org_mozilla_fenix_nightly_stable", "health"),
    ("org_mozilla_fenix_nightly_stable", "metrics"),
    ("org_mozilla_fenix_nightly_stable", "sync"),
]

def fetch_partitions(client, dataset, table):
    query = f"""
    SELECT partition_id, total_rows
    FROM `{PROJECT}.{dataset}.INFORMATION_SCHEMA.PARTITIONS`
    WHERE table_name = '{table}'
      AND partition_id NOT IN ('__UNPARTITIONED__', '__NULL__')
    """
    return {row.partition_id: row.total_rows for row in client.query(query).result() if row.total_rows > 0}

client = bigquery.Client()

for dataset, base_name in TABLES:
    v1 = fetch_partitions(client, dataset, f"{base_name}_v1")
    v2 = fetch_partitions(client, dataset, f"{base_name}_v2")

    mismatches = []
    for partition_id in sorted(set(v1) | set(v2)):
        v1_count = v1.get(partition_id)
        v2_count = v2.get(partition_id)
        if v1_count == v2_count:
            continue
        # Allow up to 5% difference from shredder
        if v1_count is not None and v2_count is not None and v2_count < v1_count and (v1_count - v2_count) / v1_count <= 0.05:
            continue
        mismatches.append((partition_id, v1_count, v2_count))

    print(f"{dataset}.{base_name}: {len(mismatches)} mismatched partition(s)")
    for partition_id, v1_count, v2_count in mismatches:
        print(f"  {partition_id}: v1={v1_count}, v2={v2_count}")

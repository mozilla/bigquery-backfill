"""
Create a insert SQL expression to merge the deduplicated data with the production stable tables.

This script is needed as the order of columns doesn't match between production schema and backfill schemas.
It is necessary to explicitly select columns.
"""

from typing import Optional, Iterable, List, Dict
import yaml

def generate_compatible_select_expression(
    source_schema,
    target_schema
) -> str:
    """Generate the select expression for the source schema based on the target schema."""

    def _type_info(node):
        """Determine the BigQuery type information from Schema object field."""
        dtype = node["type"]
        if dtype == "RECORD":
            dtype = (
                "STRUCT<"
                + ", ".join(
                    f"`{field['name']}` {_type_info(field)}"
                    for field in node["fields"]
                )
                + ">"
            )
        elif dtype == "FLOAT":
            dtype = "FLOAT64"
        if node.get("mode") == "REPEATED":
            return f"ARRAY<{dtype}>"
        return dtype

    def recurse_fields(
        _source_schema_nodes: List[Dict],
        _target_schema_nodes: List[Dict],
        path=None,
    ) -> str:
        if path is None:
            path = []

        select_expr = []
        source_schema_nodes = {n["name"]: n for n in _source_schema_nodes}
        target_schema_nodes = {n["name"]: n for n in _target_schema_nodes}

        # iterate through fields
        for node_name, node in target_schema_nodes.items():
            dtype = node["type"]
            node_path = path + [node_name]
            node_path_str = ".".join(node_path)

            if node_name in source_schema_nodes:  # field exists in app schema
                # field matches, can query as-is
                if node["name"] == node_name and (
                    # don't need to unnest scalar
                    dtype != "RECORD"
                ):
                    select_expr.append(node_path_str)
                elif (
                    dtype == "RECORD"
                ):  # for nested fields, recursively generate select expression
                    if (
                        node.get("mode", None) == "REPEATED"
                    ):  # unnest repeated record
                        select_expr.append(
                            f"""
                                ARRAY(
                                    SELECT
                                        STRUCT(
                                            {recurse_fields(
                                                source_schema_nodes[node_name]['fields'],
                                                node['fields'],
                                                [node_name],
                                            )}
                                        )
                                    FROM UNNEST({node_path_str}) AS `{node_name}`
                                ) AS `{node_name}`
                            """
                        )
                    else:  # select struct fields
                        select_expr.append(
                            f"""
                                STRUCT(
                                    {recurse_fields(
                                        source_schema_nodes[node_name]['fields'],
                                        node['fields'],
                                        node_path,
                                    )}
                                ) AS `{node_name}`
                            """
                        )
                else:  # scalar value doesn't match, e.g. different types
                    select_expr.append(
                        f"CAST(NULL AS {_type_info(node)}) AS `{node_name}`"
                    )
            else:  # field not found in source schema
                select_expr.append(
                    f"CAST(NULL AS {_type_info(node)}) AS `{node_name}`"
                )

        return ", ".join(select_expr)

    return recurse_fields(
        source_schema["fields"],
        target_schema["fields"],
    )

def main():
    with open("stable_metrics.yaml") as stream:
        stable_schema = yaml.safe_load(stream)

    with open("backfill_metrics.yaml") as stream:
        backfill_schema = yaml.safe_load(stream)

    select_expression = generate_compatible_select_expression(backfill_schema, stable_schema)

    with open("insert.sql", "w") as f:
        insert_statement = f"""
        INSERT INTO
          `moz-fx-data-shared-prod.firefox_desktop_stable.metrics_v1`
        {select_expression}
        FROM
          `moz-fx-data-backfill-1.firefox_desktop_stable.metrics_v1`
        WHERE
          DATE(submission_timestamp) > "2024-10-01"
        """
        f.write(insert_statement)

if __name__ == "__main__":
    main()

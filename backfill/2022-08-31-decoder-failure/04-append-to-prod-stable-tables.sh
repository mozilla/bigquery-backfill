#!/bin/bash
set -exo pipefail

# needs to be run by DSRE or someone entity with stable table write access
PROJECT="moz-fx-data-backfill-10"
# FIXME update this list, see README
TABLES=(
)

for table in $TABLES ; do
  bq cp --append_table "${PROJECT}:${table}" "moz-fx-data-shared-prod:${table}"
done

#!/bin/bash

# cross-platform date range
function ds_range {
    DS_START=$1 DS_END=$2 python3 - <<EOD
from datetime import date, timedelta, datetime
from os import environ
def parse(ds):
    return datetime.strptime(ds, "%Y-%m-%d")
start_date = parse(environ["DS_START"])
end_date = parse(environ["DS_END"])
dates = []
# inclusive date range
for i in range((end_date - start_date).days + 1):
    dt = start_date + timedelta(i)
    dates.append(dt.strftime("%Y-%m-%d"))
print("\n".join(dates))
EOD
}

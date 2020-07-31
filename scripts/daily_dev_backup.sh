#!/bin/bash
# create copy of database w/o users data; for use by contributors

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

pg_dump -c --if-exists --no-acl --no-owner --exclude-table-data=users "$DATABASE_URL" | gzip > wokewindows_db.sql.gz
aws s3 cp wokewindows_db.sql.gz 's3://wokewindows-data/wokewindows_db.sql.gz' --acl public-read

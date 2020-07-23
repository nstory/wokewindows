#!/bin/bash
# daily database backup job

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

pg_dump -c --if-exists --no-acl --no-owner "$DATABASE_URL" | gzip > wokewindows_db_$(date -I).sql.gz
aws s3 cp wokewindows_db_*.gz 's3://wokewindows-backup/'

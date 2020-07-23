#!/bin/bash
# usage: ./scripts/load_db_backup.sh backup.sql.gz
# warning: this will drop your development database!

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

bundle exec rails db:reset
gzcat $1 | psql -v ON_ERROR_STOP=1 cops
bundle exec rails db:environment:set RAILS_ENV=development

#!/bin/bash
# daily cron job

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

rails r 'Incident.find_each{|i| i.geocode!; i.save}'
rails r 'Detail.find_each{|d| d.geocode!; d.save}'

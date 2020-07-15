#!/bin/bash
# daily cron job

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

rails 'ckan:archive[crime-incident-reports-august-2015-to-date-source-new-system,Crime Incident Reports (August 2015 - To Date) (Source - New System),crime_incident_reports]'
rails 'ckan:archive[public-works-active-work-zones,Public Works Active Work Zones,public_works_active_work_zones]'
rails 'journals:download'
rails 'importers:run'

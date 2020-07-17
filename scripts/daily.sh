#!/bin/bash
# daily cron job

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# download Public Works Department data
rails 'ckan:archive[public-works-active-work-zones,Public Works Active Work Zones,public_works_active_work_zones]'

# download and import incident report data
rails 'ckan:archive[crime-incident-reports-august-2015-to-date-source-new-system,Crime Incident Reports (August 2015 - To Date) (Source - New System),crime_incident_reports]'
rails 'journals:download'
rails 'importers:run'

# download and import bpd news articles
rails 'articles:download'
rails r 'Importer::BpdNewsArticles.import_all'

rails 'counters:fix'

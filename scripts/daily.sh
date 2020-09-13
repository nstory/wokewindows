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
rails r 'Populater::IncidentsGeocode.populate'

# download and import bpd news articles
rails 'articles:download'
rails r 'Importer::Article::BpdNews.import_all'
rails r 'Populater::ArticlesOfficers.populate'

# update counter_culture counters
rails 'counters:fix'

# exports
# psql "$DATABASE_URL" -c "\COPY incidents TO STDOUT CSV HEADER" | gzip > incidents.csv.gz
# aws s3 cp incidents.csv.gz 's3://wokewindows-data/incidents.csv.gz' --acl public-read

rails 'exports:export[Exporter::Officers,s3://wokewindows-data/exports/officers.csv]'
rails 'exports:export[Exporter::ComplaintsOfficers,s3://wokewindows-data/exports/complaints_officers.csv]'
rails 'exports:export[Exporter::Contributions,s3://wokewindows-data/exports/contributions.csv]'
rails 'exports:export[Exporter::Details,s3://wokewindows-data/exports/details.csv]'
rails 'exports:export[Exporter::FieldContacts,s3://wokewindows-data/exports/field_contacts.csv]'
rails 'exports:export[Exporter::FieldContactNames,s3://wokewindows-data/exports/field_contact_names.csv]'
rails 'exports:export[Exporter::Citations,s3://wokewindows-data/exports/citations.csv]'
rails 'exports:export[Exporter::Incidents,s3://wokewindows-data/exports/incidents.csv]'

rails sitemap:refresh:no_ping

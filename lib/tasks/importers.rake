namespace :importers do
  desc "download files from S3 and run importers"
  task run: :environment do
    # lazy developer shells out
    `mkdir -p data/pdfs`
    `aws s3 sync 's3://wokewindows-data/pdfs/' data/pdfs/`
    latest_report = `aws s3 ls 's3://wokewindows-data/crime_incident_reports/' | awk '{print $4}' | sort -r | head -1`.strip
    `aws s3 cp 's3://wokewindows-data/crime_incident_reports/#{latest_report}' data/crime_incident_reports.csv.gz`

    # import the latest crime_incident_reports.csv.gz file
    Importer::CrimeIncidentReports.import_non_legacy

    # import the journal pdf files; files that have already been imported won't
    # be imported again b/c the importer tracks previous imports
    Importer::DistrictJournal.import_all

    # create any new officers found in the district journals
    # Populater::OfficersFromIncidents.populate

    # set the officer field on each Incident
    Populater::IncidentOfficers.populate

    # update incident counter cache on officers
    Incident.counter_culture_fix_counts
  end
end

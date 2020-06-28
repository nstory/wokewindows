namespace :crime_incident_reports do
  desc "download latest report from data.boston.gov and upload to s3"
  task download: :environment do
    gz_file_name = '/tmp/crime_incident_report.csv.gz'
    s3 = S3.new("us-east-1",  "wokewindows-data")
    response = Ckan.new.package_show(
      "crime-incident-reports-august-2015-to-date-source-new-system"
    )
    resource = response.resources.first
    date_time = resource.last_modified.sub(/\..*/, "")
    key = "crime_incident_reports/#{date_time}.csv.gz"
    if !s3.object_exists?(key)
      Rails.logger.info "#{resource.url} -> #{gz_file_name}"
      Zlib::GzipWriter.open(gz_file_name) do |gz|
        IO.copy_stream(Downloader.new(resource.url).open, gz)
      end
      Rails.logger.info "#{gz_file_name} -> #{key}"
      s3.upload_object(key, File.open(gz_file_name, "rb"))
    end
  end
end

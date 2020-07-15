namespace :ckan do
  desc "downloads specified file from data.boston.gov and saves to S3"
  task :archive, [:package, :name, :path] => :environment do |t, args|
    # gather arguments and configuration
    package = args[:package]
    name = args[:name]
    path = args[:path]
    region = ENV.fetch("CKAN_S3_REGION", "us-east-1")
    bucket = ENV.fetch("CKAN_S3_BUCKET", "wokewindows-data")

    # query Ckan to get latest version of resource
    response = Ckan.new.package_show(package)
    resource = response.resources.find { |r| r.name.include?(name) }

    # check if we've already copied the resource to S3
    resource_date_time = resource.last_modified.sub(/\..*/, "")
    key = "#{path}/#{resource_date_time}.gz"
    s3 = S3.new(region, bucket)
    return if s3.object_exists?(key)

    # copy the resource to S3
    tmp_file_name = "/tmp/ckan_archive_tmp_file"
    Rails.logger.info "#{resource.url} -> #{tmp_file_name}"
    Zlib::GzipWriter.open(tmp_file_name) do |gz|
      IO.copy_stream(Downloader.new(resource.url).open, gz)
    end
    Rails.logger.info "#{tmp_file_name} -> #{key}"
    s3.upload_object(key, File.open(tmp_file_name, "rb"))
  end
end

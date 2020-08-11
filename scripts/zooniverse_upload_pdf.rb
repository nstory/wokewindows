require "csv"
require "pry"

def parse_args
  if ARGV.count < 2
    puts """
  Usage: zooniverse_upload_pdf.rb SUBJECT_SET_ID PDF_FILE

  This script uploads a PDF document to Zooniverse. PDFs are not natively supported,
  so this script breaks the PDF up into JPEG images and uploads those.
    """.strip
    exit 1
  end

  $subject_set_id = ARGV.fetch(0)
  $pdf_file = ARGV.fetch(1)
end

def split_and_upload
  Dir.mktmpdir do |dir|
    basename = File.basename($pdf_file, ".pdf")
    system('pdftocairo', '-jpeg', $pdf_file, "#{dir}/#{basename}")
    files = Dir.glob("#{dir}/*.jpg").sort
    files.each do |file|
      system('aws', 's3', 'cp', file, 's3://wokewindows-data/zooniverse/', '--acl', 'public-read')
    end
    urls = files.map { |file| "https://wokewindows-data.s3.amazonaws.com/zooniverse/#{File.basename(file)}" }
    urls
  end
end

def upload_subject(urls)
  Tempfile.create do |tmpfile|
    incident_number = File.basename($pdf_file, ".pdf")
    tmpfile.write(
      ["incident_number", *((1 ... urls.count).map { |c| "url_#{c}" })].to_csv
    )
    tmpfile.write(
      [incident_number, *urls].to_csv
    )
    tmpfile.flush
    rs = (2 ... urls.count+2).map { |c| ["-m", "image/jpeg", "-r", c.to_s ] }.flatten
    system("panoptes", "subject-set", "upload-subjects", *rs, $subject_set_id, tmpfile.path)
  end
end

parse_args
urls = split_and_upload
upload_subject(urls)

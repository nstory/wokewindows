namespace :journals do
  desc "downloads journals from bpdnews.com and upload to S3"
  task download: :environment do
    s3 = S3.new("us-east-1",  "wokewindows-data")
    pdfs = BpdNews.new.pdfs

    max_dups = 10

    pdfs.each do |pdf|
      key = "pdfs/#{pdf.sub(%r{^.*/}, "")}"
      if s3.object_exists?(key)
        max_dups -= 1
        break if max_dups <= 0
      else
        Rails.logger.info "#{pdf} -> #{key}"
        s3.upload_object(key, Downloader.new(pdf).open)
      end
    end
  end
end

class SitemapsController < ApplicationController
  # fetches the passed in file from S3 and sends to client; the entry in
  # routes.rb ensures only sitemap* can be retrieved -- is this safe?
  def show
    s3 = S3.new("us-east-1", "wokewindows-data")
    send_data(s3.get_body(params[:id]).read)
  end
end

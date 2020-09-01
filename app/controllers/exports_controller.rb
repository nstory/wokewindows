class ExportsController < ApplicationController
  def index
    @exports = exports.map do |e|
      %r{exports/(.*)\.csv}.match(e.key)
      [$1, e]
    end.to_h
  end

  private
  def exports
    Rails.cache.fetch("exports.export_list") do
      s3 = S3.new("us-east-1", "wokewindows-data")
      s3.objects("exports").map do |o|
        OpenStruct.new(last_modified: o.last_modified, size: o.size, public_url: o.public_url, key: o.key)
      end
    end
  end
end

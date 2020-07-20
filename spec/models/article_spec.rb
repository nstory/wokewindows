require 'rails_helper'

describe Article do
  describe "#source" do
    {
      "https://bpdnews.com/xyzzy" => "bpdnews.com",
       "https://www.bostonglobe.com/sdfdf" => "Boston Globe",
       "https://npaper-wehaa.com/baystatebanner/xx" => "Bay State Banner",
       "https://www.wgbh.org/xyzzy" => "WGBH",
       "https://wokewindows-data.s3.amazonaws.com/pax_centurion/pax_centurion_2014_september.pdf#page=22" => "Pax Centurion"
    }.each do |url, source|
      it "returns #{source}" do
        expect(Article.new(url: url).source).to eql(source)
      end
    end
  end
end

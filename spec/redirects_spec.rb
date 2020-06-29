describe "redirects" do
  ["http://wokewindows.com", "http://wokewindows.org", "https://wokewindows.herokuapp.com"].each do |url|
    it "redirect #{url}" do
      response = Net::HTTP.get_response(URI(url))
      expect(response.code).to eql("302")
      expect(response.to_hash).to include(
        "location" => ["https://www.wokewindows.org"]
      )
    end
  end
end

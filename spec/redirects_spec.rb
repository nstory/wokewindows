describe "redirects" do
  ["http://wokewindows.com", "http://wokewindows.org", "https://wokewindows.herokuapp.com"].each do |url|
    xit "redirect #{url}" do
      response = Net::HTTP.get_response(URI(url))
      expect(response.code).to match(/^3/)
      expect(response.to_hash["location"].first).to match(%r{^https://www\.wokewindows\.org/?$})
    end
  end
end

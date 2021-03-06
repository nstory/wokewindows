describe Ckan do
  let(:ckan) { Ckan.new("http://example.wokewindows.org/") }

  describe "package_show" do
    let(:response) { file_fixture("package_show.json").read }
    before do
      expect(Net::HTTP).to receive(:get).and_return(response)
    end

    it "parses the response" do
      response = ckan.package_show("foobar")
      r = response.resources.first
      expect(r.url).to match(/^http.*tmprwwzjygz.csv$/)
      expect(r.last_modified).to eql("2020-06-28T11:02:02.471645")
      expect(r.name).to eql("Crime Incident Reports (August 2015 - To Date) (Source - New System)")
      expect(response.resources.second.name).to eql("RMS_Crime_Incident_Field_Explanation")
    end
  end
end

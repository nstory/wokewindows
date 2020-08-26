describe ZipCode do
  describe "#neighborhood_or_city" do
    let(:zip) { ZipCode.new({ zip: 90210, city: "FooBar" }) }

    it "returns city if zip is not in a neighborhood" do
      expect(zip.neighborhood_or_city).to eql("FooBar")
    end

    it "returns neighborhood" do
      zip.zip = 2130
      expect(zip.neighborhood_or_city).to eql("Jamaica Plain")
    end
  end
end

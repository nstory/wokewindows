describe ZipCode do
  describe "#neghiborhood" do
    let(:zip) { ZipCode.new({ zip: 90210, city: "FooBar" }) }

    it "returns city if zip is not in a neighborhood" do
      expect(zip.neighborhood).to eql("FooBar")
    end

    it "returns neighborhood" do
      zip.zip = 2130
      expect(zip.neighborhood).to eql("Jamaica Plain")
    end
  end
end

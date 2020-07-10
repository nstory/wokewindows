describe Detail do
  let(:detail) { Detail.new(street: "FOO ST", street_no: "12", xstreet: "BAR CT") }
  describe "#address" do
    it "gives number and street" do
      expect(detail.address).to eql("12 FOO ST")
    end

    it "gives street and xstreet if no number" do
      detail.street_no = nil
      expect(detail.address).to eql("FOO ST & BAR CT")
    end

    it "gives street if no xstreet and no number" do
      detail.street_no = nil
      detail.xstreet = nil
      expect(detail.address).to eql("FOO ST")
    end

    it "is nil if no street, xstreet, nor number" do
      detail.street_no = nil
      detail.xstreet = nil
      detail.street = nil
      expect(detail.address).to eql(nil)
    end
  end

  describe "#geocode" do
    let(:geocode) { Geocode.new(latitude: 12.34, longitude: 23.45) }
    it "looks up address" do
      expect(Geocode).to receive(:geocode_address).with("FOO ST", "12").and_return(geocode)
      detail.geocode!
      expect(detail.latitude).to eql(12.34)
      expect(detail.longitude).to eql(23.45)
    end

    it "looks up intersection" do
      expect(Geocode).to receive(:geocode_intersection).with("FOO ST", "BAR CT").and_return(geocode)
      detail.street_no = nil
      detail.geocode!
      expect(detail.latitude).to eql(12.34)
      expect(detail.longitude).to eql(23.45)
    end
  end
end

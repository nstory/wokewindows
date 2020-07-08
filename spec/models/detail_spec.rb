describe Detail do
  describe "#address" do
    let(:detail) { Detail.new(street: "FOO ST", street_no: "12", xstreet: "BAR CT") }
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
end

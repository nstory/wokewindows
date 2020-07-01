describe Forfeiture do
  describe "#new_style_case_number" do
    it "transforms old-style to new-style" do
      expect(Forfeiture.new(sucv: "2015-2781G").new_style_case_number).to eql("1584CV02781")
    end

    it "normalizes new-style" do
      expect(Forfeiture.new(sucv: "15-84CV02931").new_style_case_number).to eql("1584CV02931")
    end

    it "returns nil if sucv is invalid" do
      expect(Forfeiture.new(sucv: "XXX").new_style_case_number).to eql(nil)
    end
  end
end

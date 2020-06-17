describe ApplicationHelper do
  describe "format_date" do
    it "formats a date" do
      expect(helper.format_date("2012-06-29")).to eql("Jun 29, 2012")
    end

    it "returns unknown for nil" do
      expect(helper.format_date(nil)).to match(/unknown/)
    end

    it "returns unknown for malformed" do
      expect(helper.format_date("xyzzy foo")).to match(/unknown/)
    end
  end

  describe "format_zip" do
    it "formats a zip" do
      expect(helper.format_zip("1234")).to eql("01234")
    end

    it "returns unknown for nil" do
      expect(helper.format_zip(nil)).to match(/unknown/)
    end
  end
end

describe Parser::FieldContact do
  let(:parser) { Parser::FieldContact.new(file) }
  let(:attribution) { parser.attribution }
  let(:records) { parser.records }

  describe "mark43 record" do
    let(:file) { file_fixture("mark43_sample.csv") }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("FC19000622")
      expect(r[:narrative]).to match(/^About.*released\.$/m)
    end

    it "attributes" do
      expect(attribution.filename).to eql("mark43_sample.csv")
      expect(attribution.category).to eql("field_contact")
      expect(attribution.url).to eql(nil)
    end
  end

  describe "rms record" do
    let(:file) { file_fixture("rms_sample.csv") }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("F190047193")
    end
  end
end

describe Parser::FieldContact do
  let(:records) { parser.records }

  describe "mark43 record" do
    let(:file) { file_fixture("mark43_sample.csv") }
    let(:parser) { Parser::FieldContact.new(file) }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("FC19000622")
      expect(r[:narrative]).to match(/^About.*released\.$/m)
    end
  end

  describe "rms record" do
    let(:file) { file_fixture("rms_sample.csv") }
    let(:parser) { Parser::FieldContact.new(file) }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("F190047193")
    end
  end
end

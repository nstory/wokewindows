describe Parser::FieldContactName do
  let(:records) { parser.records }
  let(:parser) { Parser::FieldContact.new(file) }

  describe "mark43 record" do
    let(:file) { file_fixture("mark43_name_sample.csv") }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("FC19000186")
    end
  end

  describe "rms record" do
    let(:file) { file_fixture("rms_name_sample.csv") }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("F190047826")
    end
  end
end

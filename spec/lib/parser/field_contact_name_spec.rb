describe Parser::FieldContactName do
  let(:parser) { Parser::FieldContactName.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  describe "mark43 record" do
    let(:file) { file_fixture("mark43_name_sample.csv") }
    it "parses a record" do
      r = records.first
      expect(r[:fc_num]).to eql("FC19000186")
    end

    it "attributes" do
      expect(attribution.filename).to eql("mark43_name_sample.csv")
      expect(attribution.category).to eql("field_contact_name")
      expect(attribution.url).to eql(nil)
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

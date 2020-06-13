describe Parser::FieldContact do
  let(:file) { file_fixture("mark43_sample.csv") }
  let(:parser) { Parser::FieldContact.new(file) }
  let(:records) { parser.records }

  it "parses a record" do
    r = records.first
    expect(r[:fc_num]).to eql("FC19000622")
    expect(r[:narrative]).to match(/^About.*released\.$/m)
  end
end

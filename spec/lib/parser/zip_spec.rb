describe Parser::Zip do
  let(:file) { file_fixture("sample_zipcode.csv") }
  let(:parser) { Parser::Zip.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    record = records.first
    expect(record[:zip]).to eql("14837")
    expect(record[:dst]).to eql("1")
  end

  it "attributes" do
    expect(attribution.filename).to eql("sample_zipcode.csv")
    expect(attribution.category).to eql("zipcode_csv")
    expect(attribution.url).to eql(nil)
  end
end

describe Parser::DetailRecords do
  let(:file) { file_fixture("sample_detail_records.csv") }
  let(:parser) { Parser::DetailRecords.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    r = records.first
    expect(r[:customer_name]).to eql("NATIONAL GRID")
  end
end

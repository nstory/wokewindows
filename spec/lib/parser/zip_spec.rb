describe Parser::Zip do
  let(:file) { file_fixture("sample_zipcode.csv") }
  let(:records) { Parser::Zip.new(file).records }

  it "parses a record" do
    record = records.first
    expect(record[:zip]).to eql("14837")
    expect(record[:dst]).to eql("1")
  end
end

describe Parser::FioPeople do
  let(:file) { file_fixture("sample_fio_people.csv") }
  let(:parser) { Parser::FioPeople.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    r = records.first
    expect(r[:fc_num]).to eql("F180037700")
    expect(r[:gender]).to eql("man")
  end

  it "attributes" do
    expect(attribution.category).to eql("bpd_fio_data")
    expect(attribution.url).to eql(nil)
  end
end

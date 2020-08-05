describe Parser::FioContacts do
  let(:file) { file_fixture("sample_fio_contacts.csv") }
  let(:parser) { Parser::FioContacts.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    r = records.first
    expect(r[:supervisor]).to eql("11586")
    expect(r[:basis]).to eql("encounter")
    expect(r[:narrative]).to match(/check of the vehicles/)
  end

  it "attributes" do
    expect(attribution.category).to eql("bpd_fio_data")
    expect(attribution.url).to eql(nil)
  end
end

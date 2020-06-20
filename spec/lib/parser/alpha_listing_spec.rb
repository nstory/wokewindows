describe Parser::AlphaListing do
  let(:file) { file_fixture("sample_alpha_listing.csv") }
  let(:parser) { Parser::AlphaListing.new(file) }
  let(:records) { parser.records.to_a }
  let(:attribution) { parser.attribution }

  it "parses a row" do
    record = records.first
    expect(record[:empl_id]).to eql("106724")
    expect(record[:name]).to eql("McMullin,Nicole")
  end

  it "attributes" do
    expect(attribution.filename).to eql("sample_alpha_listing.csv")
    expect(attribution.category).to eql("alpha_listing")
    expect(attribution.url).to eql(nil)
  end
end

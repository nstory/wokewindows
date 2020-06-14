describe Parser::AlphaListing do
  let(:file) { file_fixture("sample_alpha_listing.csv") }
  let(:records) { Parser::AlphaListing.new(file).records.to_a }

  it "parses a row" do
    record = records.first
    expect(record[:empl_id]).to eql("106724")
    expect(record[:name]).to eql("McMullin,Nicole")
  end
end

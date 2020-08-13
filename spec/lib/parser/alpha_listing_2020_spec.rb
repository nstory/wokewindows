describe Parser::AlphaListing2020 do
  let(:file) { file_fixture("sample_alpha_listing_20200715.csv") }
  let(:parser) { Parser::AlphaListing2020.new(file) }
  let(:records) { parser.records.to_a }
  let(:attribution) { parser.attribution }

  it "parses a row" do
    record = records.first
    expect(record[:empl_id]).to eql("086128")
    expect(record[:name]).to eql("Conway,John D")
    expect(record[:percopy_rank]).to eql("07")
    expect(record[:rank_rank]).to eql("Sergt")
    expect(record[:orgcode]).to eql("47110")
    expect(record[:org_description]).to eql("MOBILE OPERATIONS PATROL /SWAT")
    expect(record[:title]).to eql("Police Sergeant/Mobi")
    expect(record[:badge]).to eql("00541")
    expect(record[:status]).to eql("A")
    expect(record[:asof]).to eql("7/15/20")
  end

  it "attributes" do
    expect(attribution.category).to eql("alpha_listing_20200715")
  end
end

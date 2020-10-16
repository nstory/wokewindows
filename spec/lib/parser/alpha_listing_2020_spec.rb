describe Parser::AlphaListing2020 do
  include_context "parser"
  let(:file) { file_fixture("sample_alpha_listing_20200715.csv") }

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
end

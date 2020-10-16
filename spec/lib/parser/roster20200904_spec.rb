describe Parser::Roster20200904 do
  include_context "parser"
  let(:file) { file_fixture("sample_roster_20200904.csv") }

  it "parses a row" do
    expect(record[:empl_id]).to eql("106726")
    expect(record[:name]).to eql("Limontas,Jean-Paul")
    expect(record[:org_description]).to eql("D-14 Detective")
    expect(record[:title]).to eql("Police Detective")
  end
end

describe Parser::CourtOvertime do
  include_context "parser"
  let(:file) { file_fixture("sample_court_overtime.csv") }

  it "parses a record" do
    expect(record[:id]).to eql("010652")
    expect(record[:assigned]).to eql("D-4 DCU SQUAD")
  end

  it "attributes" do
    expect(attribution.category).to eql("court_overtime")
  end

  it "skips record with blank id" do
    expect(records.none? { |r| r[:id].blank? }).to eql(true)
  end
end

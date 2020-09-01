describe Parser::Fec do
  include_context "parser"
  let(:file) { file_fixture("sample_fec.csv") }

  it "parses a row" do
    expect(record[:contributor_name]).to eql("PATERSON, CORNELL")
    expect(record[:memo_text]).to eql("EARMARKED FOR TOM STEYER 2020 (C00711614)")
    expect(record[:receipt_type_full]).to eql("EARMARK")
  end

  it "attributes" do
    expect(attribution.category).to eql("fec")
  end
end

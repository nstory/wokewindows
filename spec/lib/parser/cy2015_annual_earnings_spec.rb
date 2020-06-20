describe Parser::Cy2015AnnualEarnings do
  let(:file) { file_fixture("sample_cy2015_annual_earnings.csv") }
  let(:parser) { Parser::Cy2015AnnualEarnings.new(file) }
  let(:records) { parser.records.to_a }
  let(:attribution) { parser.attribution }

  it "make sure totals row is not included" do
    expect(records.last[:empl_id]).to eql("140303")
  end

  it "attributes" do
    expect(attribution.filename).to eql("sample_cy2015_annual_earnings.csv")
    expect(attribution.category).to eql("cy2015_annual_earnings")
    expect(attribution.url).to eql(nil)
  end
end

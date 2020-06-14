describe Parser::Cy2015AnnualEarnings do
  let(:file) { file_fixture("sample_cy2015_annual_earnings.csv") }
  let(:records) { Parser::Cy2015AnnualEarnings.new(file).records.to_a }

  it "make sure totals row is not included" do
    expect(records.last[:empl_id]).to eql("140303")
  end
end

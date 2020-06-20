describe Parser::EmployeeEarnings do
  let(:file) { file_fixture("sample_earnings_report.csv") }
  let(:parser) { Parser::EmployeeEarnings.new(file) }
  let(:attribution) { parser.attribution }
  let(:records) { parser.records }

  it "parses a record" do
    r = records.first
    expect(r[:name]).to eql("Lajara,Natasha Yvette")
    expect(r[:total]).to eql("136,874.80")
  end

  it "attributes" do
    expect(attribution.filename).to eql("sample_earnings_report.csv")
    expect(attribution.category).to eql("employee_earnings")
    expect(attribution.url).to eql(nil)
  end
end

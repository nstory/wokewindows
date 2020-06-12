describe LoadEmployeeEarningsReport do
  let(:file) { file_fixture("sample_earnings_report.csv") }
  let(:leer) { LoadEmployeeEarningsReport.new(file) }
  let(:records) { leer.records }

  it "parses a record" do
    r = records.first
    expect(r[:name]).to eql("Lajara,Natasha Yvette")
    expect(r[:total]).to eql("136,874.80")
  end
end

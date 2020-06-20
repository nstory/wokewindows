describe Parser::CrimeIncidentReports do
  let(:file) { file_fixture("sample_crime_incident_report.csv") }
  let(:parser) { Parser::CrimeIncidentReports.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    record = records.first
    expect(record[:incident_number]).to eql("I172036263")
  end

  it "parses all the records" do
    expect(records.count).to eql(99)
  end

  it "attributes" do
    expect(attribution.filename).to eql("sample_crime_incident_report.csv")
    expect(attribution.category).to eql("crime_incident_reports")
    expect(attribution.url).to eql(nil)
  end
end

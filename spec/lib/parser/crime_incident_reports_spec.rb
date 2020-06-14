describe Parser::CrimeIncidentReports do
  let(:file) { file_fixture("sample_crime_incident_report.csv") }
  let(:records) { Parser::CrimeIncidentReports.new(file).records }

  it "parses a record" do
    record = records.first
    expect(record[:incident_number]).to eql("I172036263")
  end

  it "parses all the records" do
    expect(records.count).to eql(99)
  end
end

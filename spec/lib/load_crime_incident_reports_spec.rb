describe LoadCrimeIncidentReports do
  let(:file) { file_fixture("sample_crime_incident_report.csv") }
  let(:reports) { LoadCrimeIncidentReports.new(file) }
  let(:records) { reports.get_records }

  it "loads an incident" do
    expect(records.first).to include({
      incident_number: "I172036263"
    })
  end

  it "loads all incidents" do
    expect(records.count).to eql(99)
  end
end

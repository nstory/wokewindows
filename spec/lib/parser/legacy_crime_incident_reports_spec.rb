describe Parser::LegacyCrimeIncidentReports do
  let(:file) { file_fixture("sample_legacy_crime_incident_report.csv") }
  let(:parser) { Parser::LegacyCrimeIncidentReports.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    r = records.to_a.second
    expect(r[:incident_number]).to eql("152040138")
    expect(r[:offense_description]).to eql("LARCENY FROM MOTOR VEHICLE")
    expect(r[:district]).to eql("A1")
    expect(r[:reporting_area]).to eql("0")
    expect(r[:occurred_on_date]).to eql("05/15/2015 04:00:00 PM")
    expect(r[:shooting]).to eql("No")
    expect(r[:ucr_part]).to eql("Part One")
    expect(r[:street]).to eql("MT VERNON PL")
    expect(r[:location]).to eql("(42.35800634, -71.06490956)")
  end

  it "attributes" do
    expect(attribution.category).to eql("legacy_crime_incident_reports")
    expect(attribution.url).to eql(nil)
  end
end

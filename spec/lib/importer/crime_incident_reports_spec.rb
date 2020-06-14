describe Importer::CrimeIncidentReports do
  let(:record) {{
    incident_number: "I92102201",
    offense_code: "3301",
    offense_code_group: "ABC 123",
    offense_description: "VERBAL DISPUTE",
    district: "E13",
    reporting_area: "583",
    shooting: "0",
    occurred_on_date: "2019-12-20 03:08:00",
    year: "2019",
    month: "12",
    day_of_week: "Friday",
    hour: "3",
    ucr_part: "Xyzzy",
    street: "DAY ST",
    lat: "42.325122",
    long: "-71.107779",
    location: "(42.32512200, -71.10777900)"
  }}

  it "imports an incident" do
    record2 = record.dup
    record2.merge!({
      offense_code: "42",
      offense_code_group: "lol",
      offense_description: "ROFL"
    })

    Importer::CrimeIncidentReports.import([record, record2])

    inc = Incident.first
    expect(inc.incident_number).to eql(92102201)
    expect(inc.district).to eql("E13")
    expect(inc.reporting_area).to eql(583)
    expect(inc.shooting).to eql(false)
    expect(inc.occurred_on_date).to eql("2019-12-20 03:08:00")
    expect(inc.ucr_part).to eql("Xyzzy")
    expect(inc.street).to eql("DAY ST")
    expect(inc.latitude).to eql(42.325122)
    expect(inc.longitude).to eql(-71.107779)
    expect(inc.offenses.count).to eql(2)
  end

  it "updates an existing record" do
    Incident.create incident_number: 92102201
    Importer::CrimeIncidentReports.import([record])
    expect(Incident.count).to eql(1)
    expect(Incident.first.district).to eql("E13")
  end

  it "imports same record twice" do
    Importer::CrimeIncidentReports.import([record, record])
    expect(Incident.count).to eql(1)
    expect(Offense.count).to eql(1)
  end

  it "rejects bizarre incident number" do
    record[:incident_number] = "TEST_TEST"
    Importer::CrimeIncidentReports.import([record])
    expect(Incident.count).to eql(0)
  end

  it "uses null" do
    record[:ucr_part] = ""
    record[:reporting_area] = ""
    record[:lat] = ""
    record[:offense_code_group] = ""
    Importer::CrimeIncidentReports.import([record])
    expect(Incident.last.ucr_part).to eql(nil)
    expect(Incident.last.reporting_area).to eql(nil)
    expect(Incident.last.latitude).to eql(nil)
    expect(Offense.first.code_group).to eql(nil)
  end
end
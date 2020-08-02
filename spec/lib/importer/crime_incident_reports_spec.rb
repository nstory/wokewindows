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
  let(:legacy_record) {{
    incident_number: "120419202",
    naturecode: "PSHOT",
    offense_description: "AGGRAVATED ASSAULT",
    main_crimecode: "04xx",
    district: "B2",
    reporting_area: "327",
    occurred_on_date: "07/08/2012 06:03:00 AM",
    weapontype: "Firearm",
    shooting: "Yes",
    domestic: "No",
    shift: "Last",
    year: "2012",
    month: "7",
    day_week: "Sunday",
    ucr_part: "Part One",
    x: "771223.1638",
    y: "2940772.099",
    street: "HOWARD AV",
    xstreetname: "",
    location: "(42.31684135, -71.07458456)"
  }}
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: "c" }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::CrimeIncidentReports.new(parser) }

  it "imports an incident" do
    record2 = record.dup
    record2.merge!({
      offense_code: "42",
      offense_code_group: "lol",
      offense_description: "ROFL"
    })
    records.push(record2)

    importer.import

    inc = Incident.first
    expect(inc.incident_number).to eql(92102201)
    expect(inc.district).to eql("E13")
    expect(inc.reporting_area).to eql(583)
    expect(inc.shooting).to eql(false)
    expect(inc.occurred_on_date).to eql("2019-12-20 03:08:00")
    expect(inc.ucr_part).to eql("Xyzzy")
    expect(inc.street).to eql("DAY ST")
    expect(inc.reported_latitude).to eql(42.325122)
    expect(inc.reported_longitude).to eql(-71.107779)
    expect(inc.latitude).to eql(42.325122)
    expect(inc.longitude).to eql(-71.107779)
    expect(inc.attributions).to eql([attribution])
    expect(inc.offenses.count).to eql(2)
    offense = inc.offenses.find { |o| o.code == 42 }
    expect(offense.code).to eql(42)
    expect(offense.code_group).to eql("lol")
    expect(offense.description).to eql("ROFL")
  end

  it "updates an existing record" do
    Incident.create incident_number: 92102201
    importer.import
    expect(Incident.count).to eql(1)
    expect(Incident.first.district).to eql("E13")
  end

  it "imports same record twice" do
    records.push(record)
    importer.import
    expect(Incident.count).to eql(1)
    expect(Incident.first.offenses.count).to eql(1)
  end

  it "rejects bizarre incident number" do
    record[:incident_number] = "TEST_TEST"
    importer.import
    expect(Incident.count).to eql(0)
  end

  it "uses null" do
    record[:ucr_part] = ""
    record[:reporting_area] = ""
    record[:location] = ""
    record[:offense_code_group] = ""
    importer.import
    inc = Incident.last
    expect(inc.ucr_part).to eql(nil)
    expect(inc.reporting_area).to eql(nil)
    expect(inc.reported_latitude).to eql(nil)
    expect(inc.latitude).to eql(nil)
    expect(inc.offenses.first.code_group).to eql(nil)
  end

  describe "importing a legacy record" do
    let(:records) { [legacy_record] }
    it "imports a legacy record" do
      importer.import
      inc = Incident.last
      expect(inc.incident_number).to eql(120419202)
      expect(inc.district).to eql("B2")
      expect(inc.reporting_area).to eql(327)
      expect(inc.occurred_on_date).to eql("2012-07-08 06:03:00")
      expect(inc.ucr_part).to eql("Part One")
      expect(inc.street).to eql("HOWARD AV")
      expect(inc.reported_latitude).to eql(42.31684135)
      expect(inc.reported_longitude).to eql(-71.07458456)
      expect(inc.latitude).to eql(42.31684135)
      expect(inc.longitude).to eql(-71.07458456)
      expect(inc.shooting).to eql(true)
      offense = inc.offenses.first
      expect(offense.code).to eql(nil)
      expect(offense.code_group).to eql(nil)
      expect(offense.description).to eql("AGGRAVATED ASSAULT")
    end

    it "parses pm date right" do
      legacy_record[:occurred_on_date] = "07/08/2012 06:03:00 PM"
      importer.import
      expect(Incident.last.occurred_on_date).to eql("2012-07-08 18:03:00")
    end

    it "parses null island as nil" do
      legacy_record[:location] = "(0.0, 0.0)"
      importer.import
      inc = Incident.last
      expect(inc.reported_latitude).to eql(nil)
      expect(inc.reported_longitude).to eql(nil)
      expect(inc.latitude).to eql(nil)
      expect(inc.longitude).to eql(nil)
    end

    it "skips records with null incident number" do
      legacy_record[:incident_number] = ""
      importer.import
      expect(Incident.count).to eql(0)
    end
  end
end

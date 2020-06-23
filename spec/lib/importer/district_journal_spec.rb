describe Importer::DistrictJournal do
  let(:record) {{
    :report_date_time=>"1/4/2018 12:21:00 AM",
    :complaint_number=>"182000830",
    :occurrence_date_time=>"1/4/2018 12:21:00 AM",
    :location_of_occurrence=>"A1 - 101 BROAD ST",
    :nature_of_incident=>"ASSAULT SIMPLE - BATTERY",
    :officer=>"042  JAMES KIRK",
    :arrests=>
    [{:name=>"MCCOY, BONES",
      :address=>"42 BOGUS ST   BSTN, MA",
      :charge=>"Assault - Assault & Battery"}]
  }}
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: "c" }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::DistrictJournal.new(parser) }

  it "imports an incident" do
    importer.import
    expect(Incident.count).to eql(1)
    inc = Incident.first
    expect(inc.incident_number).to eql(182000830)
    expect(inc.occurred_on_date).to eql("2018-01-04 00:21:00")
    expect(inc.report_date).to eql("2018-01-04 00:21:00")
    expect(inc.location_of_occurrence).to eql(["A1 - 101 BROAD ST"])
    expect(inc.nature_of_incident).to eql(["ASSAULT SIMPLE - BATTERY"])
    expect(inc.arrests.count).to eql(1)
    expect(inc.arrests.first.name).to eql("MXXXX, BXXXX")
    expect(inc.arrests.first.charge).to eql("Assault - Assault & Battery")
    expect(inc.attributions).to eql([attribution])
    expect(inc.officer_journal_name).to eql("042  JAMES KIRK")
  end

  it "updates existing record" do
    Incident.create(incident_number: 182000830)
    importer.import
    expect(Incident.count).to eql(1)
    expect(Incident.first.location_of_occurrence).to eql(["A1 - 101 BROAD ST"])
    expect(Incident.first.attributions).to eql([attribution])
  end

  it "doesn't create dup records" do
    records.push(record)
    importer.import
    expect(Incident.count).to eql(1)
  end

  it "doesn't dup location_of_occurrence or nature_of_incident or arrests or attributions" do
    importer.import
    records.push(record)
    importer.import
    expect(Incident.count).to eql(1)
    inc = Incident.last
    expect(inc.location_of_occurrence).to eql(["A1 - 101 BROAD ST"])
    expect(inc.nature_of_incident).to eql(["ASSAULT SIMPLE - BATTERY"])
    expect(inc.arrests.count).to eql(1)
    expect(inc.attributions).to eql([attribution])
  end

  it "doesn't add nil location_of_occurrence of nature_of_incident" do
    Incident.create(incident_number: 182000830)
    record[:location_of_occurrence] = ""
    record[:nature_of_incident] = ""
    importer.import
    inc = Incident.first
    expect(inc.location_of_occurrence).to eql([])
    expect(inc.nature_of_incident).to eql([])
  end

  it "doesn't add blank officer" do
    record[:officer] = ""
    importer.import
    expect(Incident.first.officer_journal_name).to eql(nil)
  end

  it "doesn't add an arrest where name starts with a number" do
    record[:arrests][0][:name] = "42 CANTERBURY ROSLINDALE MA"
    importer.import
    expect(Incident.first.arrests.count).to eql(0)
  end

  it "doesn't import record with invalid complaint number" do
    record[:complaint_number] = "2020-00"
    importer.import
    expect(Incident.count).to eql(0)
  end
end

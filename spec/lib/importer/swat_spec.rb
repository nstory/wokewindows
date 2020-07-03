describe Importer::Swat do
  let(:record) {{
    swat_id: "14-01JUN29",
    officers: [{employee_id: "001234", name: "Kirk, James"}],
    date: "10/2/2014",
    incident_numbers: ["14-2005278"]
  }}
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: nil }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::Swat.new(parser) }
  let!(:incident) { Incident.create(incident_number: 142005278) }
  let!(:officer) { Officer.create(hr_name: "Kirk, James T", employee_id: 1234) }

  it "imports a record" do
    importer.import
    s = Swat.first
    expect(s.swat_number).to eql("14-01JUN29")
    expect(s.date).to eql("2014-10-02")
    expect(s.officers.to_a).to eql([officer])
    expect(s.incidents.to_a).to eql([incident])
    expect(s.attributions).to eql([attribution])
  end

  it "doesn't import an officer twice" do
    record[:officers].push(record[:officers][0])
    importer.import
    expect(Swat.first.swats_officers.count).to eql(1)
  end

  it "doesn't import an incident twice" do
    record[:incident_numbers].push(record[:incident_numbers][0])
    importer.import
    expect(Swat.first.swats_incidents.count).to eql(1)
  end

  it "doesn't import a swat twice" do
    importer.import
    importer.import
    expect(Swat.count).to eql(1)
    expect(SwatsOfficer.count).to eql(1)
    expect(SwatsIncident.count).to eql(1)
  end
end

describe Importer::Over1000 do
  let(:record) {{
    sucv: "2013-0807E",
    amount: "$4,316.00",
    police_report_number: ["130065512"],
    date: "2/1/2013",
    motor_vehicle: "2004 Dodge Neon"
  }}
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: nil }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::Over1000.new(parser) }
  let!(:incident) { Incident.create(incident_number: 130065512) }

  it "imports a record" do
    importer.import
    f = Forfeiture.first
    expect(f.sucv).to eql("2013-0807E")
    expect(f.amount).to eql(4316.00)
    expect(f.date).to eql("2013-02-01")
    expect(f.motor_vehicle).to eql("2004 Dodge Neon")
    expect(f.attributions).to eql([attribution])
    expect(f.forfeitures_incidents.map(&:incident_number)).to eql(["130065512"])
    expect(f.incidents.to_a).to eql([incident])
    expect(incident.forfeitures.to_a).to eql([f])
  end

  it "doesn't import duplicate record" do
    importer.import
    importer.import
    expect(Forfeiture.count).to eql(1)
  end

  it "doesn't import record with null sucv" do
    record[:sucv] = ""
    importer.import
    expect(Forfeiture.count).to eql(0)
  end
end

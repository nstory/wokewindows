describe Importer::Forfeiture::Forfeiture do
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: nil }
  let(:parser) { mock_parser(records, attribution) }
  let!(:incident) { Incident.create(incident_number: 130065512) }

  describe Importer::Forfeiture::Superior do
    let(:record) {{
      case_number: "2013-0807E",
      amount: "$4,316.00",
      police_report_number: ["130065512"],
      date: "2/1/2013",
      motor_vehicle: "2004 Dodge Neon"
    }}
    let(:importer) { Importer::Forfeiture::Superior.new(parser) }
    it "imports a record" do
      importer.import
      c = Case.first
      expect(c.case_number).to eql("1384CV00807")
      expect(c.court).to eql("superior")
      expect(c.amount).to eql(4316.00)
      expect(c.date).to eql("2013-02-01")
      expect(c.motor_vehicle).to eql("2004 Dodge Neon")
      expect(c.attributions).to eql([attribution])
      expect(c.cases_incidents.map(&:incident_number)).to eql(["130065512"])
      expect(c.incidents.to_a).to eql([incident])
      expect(incident.cases.to_a).to eql([c])
    end

    it "doesn't import duplicate record" do
      importer.import
      importer.import
      expect(Case.count).to eql(1)
    end

    it "doesn't import record with null case_number" do
      record[:case_number] = ""
      importer.import
      expect(Case.count).to eql(0)
    end
  end

  describe Importer::Forfeiture::BmcDorchester do
    let(:record) {{
      case_number: "01-8389",
      amount: "$4,316.00",
      police_report_number: ["130065512"],
      date: "2/1/2013"
    }}
    let(:importer) { Importer::Forfeiture::BmcDorchester.new(parser) }

    it "imports a record" do
      importer.import
      c = Case.first
      expect(c.case_number).to eql("0107CR008389")
      expect(c.court).to eql("bmc_dorchester")
      expect(c.amount).to eql(4316.00)
      expect(c.date).to eql("2013-02-01")
      expect(c.motor_vehicle).to eql(nil)
    end
  end

  describe Importer::Forfeiture::BmcRoxbury do
    let(:record) {{
      case_number: "14-4096",
      amount: "$4,316.00",
      police_report_number: ["130065512"],
      date: "2/1/2013"
    }}
    let(:importer) { Importer::Forfeiture::BmcRoxbury.new(parser) }

    it "imports a record" do
      importer.import
      c = Case.first
      expect(c.case_number).to eql("1402CR004096")
    end
  end
end

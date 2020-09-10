describe Exporter::ComplaintsOfficers do
  let(:io) { StringIO.new }
  let(:exporter) { Exporter::ComplaintsOfficers.new }
  let(:records) { CSV.parse(io.string, headers: true) }

  describe "minimal complaint" do
    it "exports" do
      create(:complaint_officer)
      exporter.export(io)
      record = records.first
      expect(record["ia_number"]).to eql("IAD2020-0042")
      expect(record["officer_employee_id"]).to eql("14242")
    end
  end

  describe "complaint against Captain Kirk" do
    it "exports" do
      create(:complaint_officer_kirk)
      exporter.export(io)
      record = records.first
      expect(record["ia_number"]).to eql("IAD2260-0001")
      expect(record["case_number"]).to eql("1234")
      expect(record["incident_type"]).to eql("Internal investigation")
      expect(record["received_date"]).to eql("2061-05-01")
      expect(record["occurred_date"]).to eql("2061-04-20")
      expect(record["summary"]).to eql("rofl xyzzy lol")
      expect(record["name"]).to eql("James T. Kirk")
      expect(record["title"]).to eql("Cpt.")
      expect(record["badge"]).to eql("4242")
      expect(record["allegation"]).to eql("Piracy")
      expect(record["finding"]).to eql("Sustained")
      expect(record["finding_date"]).to eql("2061-06-29")
      expect(record["officer_employee_id"]).to eql("1701")
    end
  end
end

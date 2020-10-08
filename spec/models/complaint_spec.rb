describe Complaint do
  describe ".by_ia_number" do
    let!(:complaint_1) { Complaint.create({ia_number: "101"}) }
    let!(:complaint_2) { Complaint.create({ia_number: "102"}) }

    it "returns a hash by ia number" do
      expect(Complaint.by_ia_number(["101", "102", "103"])).to eql({
        "101" => complaint_1,
        "102" => complaint_2
      })
    end
  end

  describe ".finding" do
    it "returns nil if no complaint_officers" do
      expect(Complaint.new.finding).to eql(nil)
    end

    it "returns finding if all complaint_officers have same one" do
      complaint = Complaint.new(complaint_officers: [ComplaintOfficer.new(finding: "XXX"), ComplaintOfficer.new(finding: "XXX")])
      expect(complaint.finding).to eql("XXX")
    end

    it "returns Multiple if complaint_officers have different findings" do
      complaint = Complaint.new(complaint_officers: [ComplaintOfficer.new(finding: "YYY"), ComplaintOfficer.new(finding: "XXX")])
      expect(complaint.finding).to eql("Mixed")
    end

    it "returns Partially Sustained if at least one is sustained" do
      complaint = Complaint.new(complaint_officers: [ComplaintOfficer.new(finding: "Sustained"), ComplaintOfficer.new(finding: "XXX")])
      expect(complaint.finding).to eql("Partially Sustained")
    end
  end

  describe ".short_description" do
    def build_complaint(co_names)
      cos = co_names.map { |name| ComplaintOfficer.new(name: name) }
      Complaint.new(incident_type: "Citizen complaint", received_date: "2001-01-01", complaint_officers: cos)
    end

    desc_stub = "Citizen complaint received 2001-01-01"

    it "returns a basic message if no complaint_officers" do
      complaint = build_complaint([])
      expect(complaint.short_description).to eql(desc_stub)
    end

    it "returns a message with 'against <name>' if single complaint_officer" do
      complaint = build_complaint(["Doe,Jon"])
      expect(complaint.short_description).to eql(desc_stub + " against Doe,Jon")
    end

    it "returns a message with 'against an unknown officer' if single complaint_officer is unknown" do
      complaint = build_complaint(["Unknown,"])
      expect(complaint.short_description).to eql(desc_stub + " against an unknown officer")
    end

    it "returns a message with 'against an unknown officer' if single complaint_officer is nil" do
      complaint = build_complaint([nil])
      expect(complaint.short_description).to eql(desc_stub + " against an unknown officer")
    end

    it "returns a message with 'against multiple officers' if multiple complaint_officers" do
      complaint = build_complaint([ "Name1", "Name2"])
      expect(complaint.short_description).to eql(desc_stub + " against multiple officers")
    end
  end
end

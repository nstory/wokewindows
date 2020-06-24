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
  end
end

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
end

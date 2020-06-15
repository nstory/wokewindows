describe IncidentOfficer do
  let(:valid) { IncidentOfficer.new(journal_officer: "1234  FOO BAR") }
  let(:invalid) { IncidentOfficer.new(journal_officer: "3  FOO BAR") }
  let(:zi_zou) { IncidentOfficer.new(journal_officer: "148321   ZI ZOU") }

  describe ".employee_id" do
    it "returns the id" do
      expect(valid.employee_id).to eql(1234)
    end

    it "returns nil if id is invalid" do
      expect(invalid.employee_id).to eql(nil)
    end
  end

  describe ".employee_name" do
    it "returns the name" do
      expect(valid.employee_name).to eql("FOO BAR")
    end

    it "returns nil if journal_officer is invalid" do
      expect(invalid.employee_name).to eql(nil)
    end

    it "trims the name" do
      expect(zi_zou.employee_name).to eql("ZI ZOU")
    end
  end
end

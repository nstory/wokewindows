describe Incident do
  describe ".by_incident_number" do
    it "returns a hash of incidents" do
      i1 = Incident.create({incident_number: 123})
      i2 = Incident.create({incident_number: 456})
      expect(Incident.by_incident_number([123, 456])).to eql({123 => i1, 456 => i2})
      expect(Incident.by_incident_number([123])).to eql({123 => i1})
    end
  end

  describe ".location" do
    it "prefers location_of_occurrence" do
      expect(
        Incident.new(street: "XX", location_of_occurrence: ["AA", "BB"]).location
      ).to eql("AA")
    end

    it "uses street otherwise if no location_of_occurrence" do
      expect(
        Incident.new(street: "XX", location_of_occurrence: []).location
      ).to eql("XX")
    end

    it "is nil otherwise" do
      expect(
        Incident.new(street: nil, location_of_occurrence: []).location
      ).to eql(nil)
    end
  end

  describe ".officer_journal_name_id and .officer_journal_name_name" do
    let(:valid) { Incident.new(officer_journal_name: "1234  FOO BAR") }
    let(:invalid) { Incident.new(officer_journal_name: "3  FOO BAR") }
    let(:zi_zou) { Incident.new(officer_journal_name: "148321   ZI ZOU") }

    it "parses valid" do
      expect(valid.officer_journal_name_id).to eql(1234)
      expect(valid.officer_journal_name_name).to eql("FOO BAR")
      expect(zi_zou.officer_journal_name_name).to eql("ZI ZOU")
    end

    it "returns nil if id is invalid" do
      expect(invalid.officer_journal_name_id).to eql(nil)
      expect(invalid.officer_journal_name_name).to eql(nil)
    end
  end
end

describe Incident do
  describe ".by_incident_number" do
    it "returns a hash of incidents" do
      i1 = Incident.create({incident_number: 123})
      i2 = Incident.create({incident_number: 456})
      expect(Incident.by_incident_number([123, 456])).to eql({123 => i1, 456 => i2})
      expect(Incident.by_incident_number([123])).to eql({123 => i1})
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

  describe ".add_offense" do
    let(:incident) { Incident.new(incident_number: 123) }
    let(:offense) { Offense.new(code: 123, code_group: "abc", description: "xyz") }

    it "adds an offense" do
      incident.add_offense(offense)
      expect(incident.offenses).to eql([offense])
      incident.save
      expect(incident.reload.offenses).to eql([offense])
    end

    it "doesn't duplicate offenses" do
      incident.add_offense(offense)
      incident.add_offense(offense)
      expect(incident.offenses).to eql([offense])
    end
  end
end

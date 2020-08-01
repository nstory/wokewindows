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

  describe ".bag_of_text" do
    let(:incident) { Incident.new(incident_number: 123, street: "XYZZY") }
    it "puts the street in the bag of text" do
      incident.save
      expect(incident.bag_of_text).to match(/XYZZY/)
    end
  end

  describe ".geocode!" do
    let(:geocode) { Geocode.new(latitude: 12.34, longitude: 23.45) }
    let(:incident) { Incident.new }

    {
      "123 XYZZY ST" => ["XYZZY ST", "123"],
      "D4 - 123 XYZZY ST" => ["XYZZY ST", "123"],
      "12C XYZZY WAY" => ["XYZZY WAY", "12"],
      "- 123 XYZZY ST" => ["XYZZY ST", "123"],
      "13-15 XYZZY SQ" => ["XYZZY SQ", "13"],
      "133-A XYZZY ST" => ["XYZZY ST", "133"]
    }.each do |location, params|
      it "parses #{location}" do
        incident.location_of_occurrence = [location]
        expect(Geocode).to receive(:geocode_address).with(*params).and_return(geocode)
        incident.geocode!
        expect(incident.geocode_latitude).to eql(12.34)
        expect(incident.geocode_longitude).to eql(23.45)
      end
    end
  end
end

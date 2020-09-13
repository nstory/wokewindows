describe Exporter::Incidents do
  include_context "exporter"

  describe "minimal incident" do
    let!(:incident) { create(:incident) }

    it "exports" do
      export
      expect(record["incident_number"]).to eql("202000001")
    end
  end

  describe "maximal incident" do
    let!(:incident_kirk) { create(:incident_kirk) }

    it "exports" do
      export
      expect(record["incident_number"]).to eql("192103868")
      expect(record["district"]).to eql("B2")
      expect(record["reporting_area"]).to eql("282")
      expect(record["shooting"]).to eql("false")
      expect(record["occurred_on_date"]).to eql("2019-12-26 17:00:00")
      expect(record["ucr_part"]).to eql("Other")
      expect(record["street"]).to eql("WASHINGTON ST")
      expect(record["latitude"]).to eql("42.39")
      expect(record["longitude"]).to eql("-70.81")
      expect(record["report_date"]).to eql("2019-12-26 18:33:04")
      expect(record["location_of_occurrence"]).to eql("10 JEROME ST")
      expect(record["nature_of_incident"]).to eql("THREATS TO DO BODILY HARM")
      expect(record["officer_journal_name"]).to eql("106745  JOSE DIAZ")
      expect(record["geocode_latitude"]).to eql("42.39")
      expect(record["geocode_longitude"]).to eql("-70.81")
      expect(record["reported_latitude"]).to eql("34.56")
      expect(record["reported_longitude"]).to eql("45.67")
      expect(record["location_type"]).to eql("Highway/Road/Alley/Street/Sidewalk")
      expect(record["incident_clearance"]).to eql("Victim Refused to Cooperate")
      expect(record["exceptional_clearance_date"]).to eql("2019-12-28")
      expect(record["number_of_victims"]).to eql("1")
      expect(record["number_of_offenders"]).to eql("1")
      expect(record["number_of_arrestees"]).to eql("0")
      expect(record["officer_employee_id"]).to eql("1701")
    end
  end
end

describe Exporter::Citations do
  include_context "exporter"

  describe "minimal citation" do
    let!(:citation) { create(:citation) }

    it "exports" do
      export
      expect(record["ticket_number"]).to eql("T42")
    end
  end

  describe "maxmimal citation" do
    let!(:citation_kirk) { create(:citation_kirk) }

    it "exports" do
      export
      expect(record["ticket_number"]).to eql("T23")
      expect(record["issuing_agency"]).to eql("Boston Police District B-3")
      expect(record["officer_number"]).to eql("148287")
      expect(record["ticket_type"]).to eql("CRIM")
      expect(record["source"]).to eql("COURT")
      expect(record["violator_type"]).to eql("OPERATOR")
      expect(record["cdl"]).to eql("false")
      expect(record["license_class"]).to eql("AM")
      expect(record["event_date"]).to eql("2019-01-01 10:15:00")
      expect(record["location_id"]).to eql("904")
      expect(record["location_name"]).to eql("Dorchester")
      expect(record["posted_speed"]).to eql("42")
      expect(record["violation_speed"]).to eql("64")
      expect(record["posted"]).to eql("true")
      expect(record["radar"]).to eql("true")
      expect(record["clocked"]).to eql("true")
      expect(record["race"]).to eql("BLACK")
      expect(record["sex"]).to eql("MALE")
      expect(record["vehicle_color"]).to eql("GRAY")
      expect(record["make"]).to eql("JEEP GRAND")
      expect(record["model_year"]).to eql("2008")
      expect(record["sixteen_pass"]).to eql("false")
      expect(record["haz_mat"]).to eql("false")
      expect(record["amount"]).to eql("0.00")
      expect(record["paid"]).to eql("true")
      expect(record["hearing_requested"]).to eql("false")
      expect(record["court_code"]).to eql("CT_007")
      expect(record["age"]).to eql("52")
      expect(record["searched"]).to eql("false")
      expect(record["offense"]).to eql("9010A2")
      expect(record["description"]).to eql("UNLICENSED OPERATION OF MV c90 10")
      expect(record["assessment"]).to eql("1.00")
      expect(record["expected_assessment"]).to eql("2.00")
      expect(record["display_assessment"]).to eql("3.00")
      expect(record["disposition"]).to eql("NPC")
      expect(record["disposition_description"]).to eql("No Probable Cause Found")
      expect(record["major_incident"]).to eql("false")
      expect(record["surchargeable"]).to eql("true")
      expect(record["sdip_points"]).to eql("2")
      expect(record["officer_employee_id"]).to eql("1701")
    end
  end
end

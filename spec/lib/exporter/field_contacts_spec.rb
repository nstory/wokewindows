describe Exporter::FieldContacts do
  include_context "exporter"

  describe "minimal field contact" do
    let!(:field_contact) { create(:field_contact) }

    it "exports" do
      export
      expect(record["fc_num"]).to eql("FC123")
    end
  end

  describe "maxmimum field contact" do
    let!(:field_contact_kirk) { create(:field_contact_kirk) }

    it "exports" do
      export
      expect(record["fc_num"]).to eql("FC234")
      expect(record["contact_date"]).to eql("2019-12-23 01:00:00")
      expect(record["contact_officer_employee_id"]).to eql("148317")
      expect(record["contact_officer_name"]).to eql("jimmy kirk")
      expect(record["supervisor_employee_id"]).to eql("103734")
      expect(record["supervisor_name"]).to eql("admiral xyzzy")
      expect(record["street"]).to eql("huntington ave")
      expect(record["city"]).to eql("boston")
      expect(record["state"]).to eql("ma")
      expect(record["zip"]).to eql("02116")
      expect(record["frisked_searched"]).to eql("false")
      expect(record["circumstance"]).to eql("encountered")
      expect(record["basis"]).to eql("probable_cause")
      expect(record["vehicle_year"]).to eql("2013")
      expect(record["vehicle_state"]).to eql("ma")
      expect(record["vehicle_make"]).to eql("kia motors corp")
      expect(record["vehicle_model"]).to eql("optima")
      expect(record["vehicle_color"]).to eql("gray")
      expect(record["vehicle_style"]).to eql("passenger car")
      expect(record["vehicle_type"]).to eql("sedan")
      expect(record["key_situations"]).to eql("body worn camera")
      expect(record["narrative"]).to eql( "rofl lol")
      expect(record["weather"]).to eql("sunny")
      expect(record["field_contact_names_count"]).to eql("23")
      expect(record["stop_duration"]).to eql("fifteen_to_twenty_minutes")
      expect(record["search_vehicle"]).to eql("true")
      expect(record["summons_issued"]).to eql("true")
      expect(record["officer_employee_id"]).to eql("1701")
    end
  end
end

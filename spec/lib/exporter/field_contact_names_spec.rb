describe Exporter::FieldContactNames do
  include_context "exporter"

  describe "minimal field_contact_name" do
    let!(:field_contact_name) { create(:field_contact_name) }

    it "exports" do
      export
      expect(record["fc_num"]).to eql("FC123")
      expect(record["field_contact_fc_num"]).to eql("FC123")
    end
  end

  describe "maximal field_contact_name" do
    let!(:field_contact_name_kirk) { create(:field_contact_name_kirk) }

    it "exports" do
      export
      expect(record["fc_num"]).to eql("FC234")
      expect(record["race"]).to eql("black")
      expect(record["age"]).to eql("25")
      expect(record["build"]).to eql("heavy")
      expect(record["hair_style"]).to eql("afro")
      expect(record["skin_tone"]).to eql("brown")
      expect(record["ethnicity"]).to eql("not of hispanic origin")
      expect(record["other_clothing"]).to eql("blue hoodie/ jeans")
      expect(record["license_state"]).to eql("ma")
      expect(record["license_type"]).to eql("id only")
      expect(record["frisked_searched"]).to eql("true")
      expect(record["gender"]).to eql("man")
      expect(record["field_contact_fc_num"]).to eql("FC234")
    end
  end
end

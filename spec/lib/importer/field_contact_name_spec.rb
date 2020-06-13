describe Importer::FieldContactName do
  let(:mark43_record) {{
    fc_num: "FC19001631",
    contact_date: "2019-12-08 04:21:00.0",
    sex: "Female",
    race: "White",
    age: "51",
    build: "NULL",
    hair_style: "NULL",
    skin_tone: "NULL",
    ethnicity: "Unknown",
    otherclothing: "NULL",
    deceased: "0",
    license_state: "MA",
    license_type: "",
    frisk_search: "NULL"
  }}

  let(:rms_record) {{
    recnum: "100069013",
    fc_num: "FC19001631",
    contact_date: "2019-09-07 19:15:00.0",
    sex: "Male",
    race: "Black",
    age: "24",
    build: "",
    hair_style: "",
    complexion: "",
    ethnicity: "Not of Hispanic Origin",
    otherclothing: ""
  }}

  describe ".import" do
    before do
      @fc = FieldContact.create(fc_num: "FC19001631")
    end

    it "imports a mark43 record" do
      Importer::FieldContactName.import([mark43_record])
      fcn = FieldContactName.first
      expect(fcn.fc_num).to eql("FC19001631")
      expect(fcn.contact_date).to eql("2019-12-08 04:21:00.0")
      expect(fcn.sex).to eql("Female")
      expect(fcn.race).to eql("White")
      expect(fcn.age).to eql(51)
      expect(fcn.build).to eql(nil)
      expect(fcn.hair_style).to eql(nil)
      expect(fcn.skin_tone).to eql(nil)
      expect(fcn.ethnicity).to eql("Unknown")
      expect(fcn.other_clothing).to eql(nil)
      expect(fcn.deceased).to eql(false)
      expect(fcn.license_state).to eql("MA")
      expect(fcn.license_type).to eql(nil)
      expect(fcn.frisked_searched).to eql(nil)
      expect(@fc.field_contact_names.to_a).to eql([fcn])
    end

    it "imports an rms record" do
      Importer::FieldContactName.import([rms_record])
      fcn = FieldContactName.first
      expect(fcn.fc_num).to eql("FC19001631")
      expect(fcn.contact_date).to eql("2019-09-07 19:15:00.0")
      expect(fcn.sex).to eql("Male")
      expect(fcn.race).to eql("Black")
      expect(fcn.age).to eql(24)
      expect(fcn.build).to eql(nil)
      expect(fcn.hair_style).to eql(nil)
      expect(fcn.skin_tone).to eql(nil)
      expect(fcn.ethnicity).to eql("Not of Hispanic Origin")
      expect(fcn.other_clothing).to eql(nil)
      expect(@fc.field_contact_names.to_a).to eql([fcn])
    end
  end
end

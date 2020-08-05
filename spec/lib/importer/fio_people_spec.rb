describe Importer::FioPeople do
  let(:record) {{
    :fc_num=>"F160011526",
    :gender=>"man",
    :race=>"black",
    :recnum=>"100012536",
    :build=>"medium",
    :hair_style=>"short",
    :otherclothing=>"xyzzy",
    :age=>"35.0",
    :ethnicity=>"not of hispanic origin",
    :skin_tone=>"medium brown",
    :license_state=>"pa",
    :person_frisked_or_searched=>"y",
    :license_type=>"class d"
  }}
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: "c" }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::FioPeople.new(parser) }
  let!(:field_contact) { FieldContact.create!(fc_num: "F160011526") }

  it "imports record" do
    importer.import
    fcn = FieldContactName.first
    expect(fcn.fc_num).to eql("F160011526")
    expect(fcn.race).to eql("black")
    # expect(fcn.recnum).to eql("100012536")
    expect(fcn.build).to eql("medium")
    expect(fcn.hair_style).to eql("short")
    expect(fcn.other_clothing).to eql("xyzzy")
    expect(fcn.age).to eql(35)
    expect(fcn.ethnicity).to eql("not of hispanic origin")
    expect(fcn.skin_tone).to eql("medium brown")
    expect(fcn.license_state).to eql("pa")
    expect(fcn.license_type).to eql("class d")
    expect(fcn.frisked_searched).to eql(true)
    expect(fcn.gender).to eql("man")
    expect(fcn.attributions).to eql([attribution])
  end

  it "doesn't duplicate" do
    importer.import
    importer.import
    expect(FieldContactName.count).to eql(1)
  end

  it "doesn't insert if no FieldContact" do
    field_contact.delete
    importer.import
    expect(FieldContactName.count).to eql(0)
  end
end

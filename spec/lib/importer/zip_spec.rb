describe Importer::Zip do
  let(:record) {{
    zip: "02131",
    city: "Roslindale",
    state: "MA",
    latitude: "42.284678",
    longitude: "-71.13052",
    timezone: "-5",
    dst: "1"
  }}

  it "imports a record" do
    Importer::Zip.import([record])
    z = ZipCode.first
    expect(z.zip).to eql(2131)
    expect(z.city).to eql("Roslindale")
    expect(z.state).to eql("MA")
    expect(z.latitude).to eql(42.284678)
    expect(z.longitude).to eql(-71.13052)
  end

  it "doesn't dup zips" do
    Importer::Zip.import([record, record])
    expect(ZipCode.count).to eql(1)
  end
end

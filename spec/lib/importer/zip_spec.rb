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
  let(:records) { [record] }
  let(:attribution) { Attribution.new filename: "a", category: "b", url: nil }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::Zip.new(parser) }

  it "imports a record" do
    importer.import
    z = ZipCode.first
    expect(z.zip).to eql(2131)
    expect(z.city).to eql("Roslindale")
    expect(z.state).to eql("MA")
    expect(z.latitude).to eql(42.284678)
    expect(z.longitude).to eql(-71.13052)
  end

  it "doesn't dup zips" do
    records.push(record)
    importer.import
    expect(ZipCode.count).to eql(1)
  end
end

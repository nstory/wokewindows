describe Parser::Allegations do
  let(:file) { file_fixture("allegations_sample.csv") }
  let(:parser) { Parser::Allegations.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "should parse first record" do
    r = records.first
    expect(r[:ia_no]).to eql("IAD2019-0006")
    expect(r[:incident_type]).to eql("Citizen complaint")
    expect(r[:received_date]).to eql("1/14/19")
    expect(r[:title]).to eql("Ptl")
    expect(r[:first_name]).to eql("Derek")
    expect(r[:last_name]).to eql("Kelley")
    expect(r[:allegation]).to eql("Neg.Duty/Unreasonable Judge")
    expect(r[:finding]).to eql("Not Sustained")
    expect(r[:finding_date]).to eql("1/30/20")
    expect(attribution.filename).to eql("allegations_sample.csv")
    expect(attribution.category).to eql("allegations_2010_to_2020")
  end
end

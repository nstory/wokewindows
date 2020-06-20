describe Parser::BpdIaData do
  let(:file) { file_fixture("bpd_ia_data_2001_2011.txt") }
  let(:parser) { Parser::BpdIaData.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "should parse first record" do
    r = records.first
    expect(r[:ia_no]).to eql("401")
    expect(r[:case_no]).to eql("4192")
    expect(r[:incident_type]).to eql("Internal investigation")
    expect(r[:received_date]).to eql("1/2/2001")
    expect(r[:first_name]).to eql("Mark Joseph")
    expect(r[:last_name]).to eql("Loewen")
    expect(r[:title]).to eql("Police Officer")
    expect(r[:badge_id_number]).to eql("4528")
    expect(r[:allegation]).to eql("Neg.Duty/Unreasonable Judge")
    expect(r[:finding]).to eql("Sustained")
    expect(r[:finding_date]).to eql("")
  end

  it "should parse last record" do
    r = records.last
    expect(r[:ia_no]).to eql("PRE2011-229")
    expect(r[:incident_type]).to eql("Preliminary Investigation")
    expect(r[:received_date]).to eql("9/29/2011")
    expect(r[:first_name]).to eql("")
    expect(r[:last_name]).to eql("Unknown")
    expect(r[:title]).to eql("Police Officer")
    expect(r[:badge_id_number]).to eql("")
    expect(r[:allegation]).to eql("Neg.Duty/Unreasonable Judge")
    expect(r[:finding]).to eql("Pending")
    expect(r[:finding_date]).to eql("")
  end

  it "should parse a record" do
    rec = records.find { |r| r[:ia_no] == "P00101" }
    expect(rec[:case_no]).to eql("")
    expect(rec[:incident_type]).to eql("Inquiry")
    expect(rec[:received_date]).to eql("12/18/2001")
  end

  it "should parse finding_date" do
    rec = records.find { |r| r[:ia_no] == "9907" }
    expect(rec[:finding_date]).to eql("7/5/2007")
    expect(rec[:finding]).to eql("Not Sustained")
  end

  it "should attribute" do
    expect(attribution.filename).to eql("bpd_ia_data_2001_2011.txt")
    expect(attribution.category).to eql("bpd_ia_data_2001_2011")
    expect(attribution.url).to eql(nil)
  end
end

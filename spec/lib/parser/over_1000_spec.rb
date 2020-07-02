describe Parser::Over1000 do
  let(:file) { file_fixture("over_1000_sample.txt") }
  let(:parser) { Parser::Over1000.new(file) }
  let(:records) { parser.records }
  let(:attribution) { parser.attribution }

  it "parses a record" do
    r = records.first
    expect(r[:case_number]).to eql("2013-0807")
    expect(r[:amount]).to eql("$4,316.00")
    expect(r[:police_report_number]). to eql(["130065512"])
    expect(r[:date]). to eql("2/1/2013")
    expect(attribution.category).to eql("da_forfeitures")
  end

  it "parses a record with a motor vehicle" do
    r = records.third
    expect(r[:motor_vehicle]).to eql("1996 Honda Accord")
  end

  it "parses a record ith multiple police reports" do
    r = records[4]
    expect(r[:police_report_number]).to eql(%w{130171979 130172903 130177614})
  end

  it "parses a record with weird case_number" do
    r = records.last
    expect(r[:case_number]).to eql("15-84CV03005")
  end

  it "finds incident number" do
    r = records[9]
    expect(r[:police_report_number]).to eql(["130663406"])
  end

  it "doesn't find a motor vehicle" do
    r = records[10]
    expect(r[:motor_vehicle]).to eql("")
  end

  describe "bmc dorchester" do
    let(:file) { file_fixture("sample_dorchester.txt") }

    it "parses a record" do
      r = records.first
      expect(r[:case_number]).to eql("05-2981")
      expect(r[:amount]).to eql("$610.00")
      expect(r[:date]).to eql("05/10/05")
      expect(r[:police_report_number]).to eql(["050238072"])
      expect(attribution.category).to eql("da_forfeitures")
    end
  end
end

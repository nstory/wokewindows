describe Parser::IadCases20200815 do
  include_context "parser"
  let(:file) { file_fixture("sample_iad_cases_20200815.csv") }

  it "parses a row" do
    expect(record[:ia_no]).to eql("IAD2016-0187")
    expect(record[:incident_type]).to eql("Internal investigation")
    expect(record[:received_date]).to eql("5/5/16")
    expect(record[:title]).to eql("Sergeant")
    expect(record[:first_name]).to eql("James F")
    expect(record[:last_name]).to eql("Meredith")
    expect(record[:badge_id_number]).to eql("377")
    expect(record[:id_number]).to eql("2681")
    expect(record[:allegation]).to eql("Respectful Treatment")
    expect(record[:finding]).to eql("Not Sustained")
    expect(record[:finding_date]).to eql("8/4/16")
    expect(record[:action_taken]).to eql("")
  end

  it "parses action_taken" do
    r = records.to_a.third
    expect(r[:action_taken]).to eql("Suspension/Settlement Agreement")
  end
end

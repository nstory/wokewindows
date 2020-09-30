describe Parser::BostonRetirementSystem do
  include_context "parser"
  let(:file) { file_fixture("sample_boston_retirement_system.csv") }

  it "parses a row" do
    expect(record[:sort_name]).to eql("KIRK, JAMES T")
    expect(record[:job_description]).to eql("Teacher - S20315")
  end
end

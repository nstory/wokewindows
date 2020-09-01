describe Parser::Ocpf do
  include_context "parser"
  let(:file) { file_fixture("sample_ocpf.csv") }
  let(:committee_file) { file_fixture("sample_ocpf_registered.csv") }
  let(:parser) { Parser::Ocpf.new(file, committee_file) }

  it "parses a row" do
    r = records.first
    expect(r[:date]).to eql("7/5/2016")
    expect(r[:contributor]).to eql("McDonough, John")
    expect(r[:zip]).to eql("02132")
    expect(r[:source_description]).to eql("7/5/16 Deposit Report")
    expect(r[:amount]).to eql("$125.00")
    expect(r[:cpf_id]).to eql("13878")
    expect(r[:comm_name]).to eql("Conley Committee")
    expect(r[:party_affiliation]).to eql("Democratic")
    expect(r[:candidate_full_name]).to eql("Daniel F. Conley")
    expect(r[:office_type]).to eql("District Attorney")
    expect(r[:district]).to eql("Suffolk District - Suffolk County")
  end

  it "attributes" do
    expect(attribution.category).to eql("ocpf")
  end
end

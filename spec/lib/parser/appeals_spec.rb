describe Parser::Appeals do
  include_context "parser"
  let(:file) { file_fixture("sample_appeals.jsonl.gz") }

  it "parses a record" do
    expect(record[:case_type]).to eql("Appeal")
    expect(record[:files][0][:path]).to eql("9299/spr181136.pdf")
  end
end

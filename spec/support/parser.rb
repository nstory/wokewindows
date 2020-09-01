shared_context "parser" do
  let(:parser) { described_class.new(file) }
  let(:records) { parser.records }
  let(:record) { records.first }
  let(:attribution) { parser.attribution }
end

shared_context "exporter" do
  let(:io) { StringIO.new }
  let(:exporter) { described_class.new }
  let(:records) { CSV.parse(io.string, headers: true) }
  let(:record) { records.first }

  def export
    exporter.export(io)
  end
end

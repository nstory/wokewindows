describe LoadCsv do
  let(:filename) { file_fixture("sample_bpd_annual_earnings.csv") }
  let(:lbae) { LoadCsv.new(filename) }
  let(:records) { lbae.records }

  it "loads a record" do
    rec = records.first
    expect(rec[:name]).to eql("Lamonica,Anthony F")
    expect(rec[:empl_id]).to eql("075660")
  end
end

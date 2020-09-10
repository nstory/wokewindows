describe Exporter::Contributions do
  let(:io) { StringIO.new }
  let(:exporter) { Exporter::Contributions.new }
  let(:records) { CSV.parse(io.string, headers: true) }
  let(:record) { records.first }

  it "exports" do
    create(:contribution_kirk)
    exporter.export(io)
    expect(record["date"]).to eql("2004-04-20")
    expect(record["contributor"]).to eql("James")
    expect(record["zip"]).to eql("02152")
    expect(record["employer"]).to eql("City of Boston")
    expect(record["occupation"]).to eql("Law Enforcement")
    expect(record["amount"]).to eql("25.00")
    expect(record["committee_name"]).to eql("Travaglini Committee")
    expect(record["cpf_id"]).to eql("11470")
    expect(record["candidate_full_name"]).to eql("Robert E. Travaglini")
    expect(record["office_type"]).to eql("Senate")
    expect(record["district"]).to eql("1st Suffolk & Middlesex")
    expect(record["party_affiliation"]).to eql("Democratic")
    expect(record["committee_id"]).to eql("C42")
    expect(record["memo_text"]).to eql("da memo")
    expect(record["receipt_type_full"]).to eql("da receipt")
    expect(record["officer_employee_id"]).to eql("1701")
  end
end

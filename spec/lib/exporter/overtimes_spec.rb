describe Exporter::Overtimes do
  include_context "exporter"
  let!(:overtime_kirk) { create(:overtime_kirk) }

  it "exports" do
    export
    expect(record["employee_id"]).to eql("1701")
    expect(record["name"]).to eql("Kirk,James")
    expect(record["rank"]).to eql("SgtDet")
    expect(record["assigned"]).to eql("A-1 DCU SQUAD")
    expect(record["charged"]).to eql("A-1 DCU SQUAD")
    expect(record["date"]).to eql("2014-01-02")
    expect(record["code"]).to eql("280")
    expect(record["description"]).to eql("COURT:TRIAL")
    expect(record["start_time"]).to eql("0830")
    expect(record["end_time"]).to eql("1030")
    expect(record["worked_hours"]).to eql("2.0")
    expect(record["ot_hours"]).to eql("4.0")
    expect(record["officer_employee_id"]).to eql("1701")
  end
end

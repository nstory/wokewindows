describe Importer::Overtimes do
  include_context "importer"

  let(:record) {{
    :id=>"001701",
    :name=>"Kirk,James",
    :rank=>"SgtDet",
    :assigned=>"A-1 DCU SQUAD",
    :charged=>"A-1 DCU SQUAD",
    :otdate=>"02-Jan-14",
    :descriptions=>"COURT CODE ONLY",
    :otcode=>"280",
    :description=>"COURT:TRIAL",
    :starttime=>"0830",
    :endtime=>"1030",
    :wrkdhrs=>"2",
    :othours=>"4"
  }}

  let!(:officer_kirk) { create(:officer_kirk) }

  it "imports record" do
    importer.import
    ot = Overtime.first
    expect(ot.employee_id).to eql(1701)
    expect(ot.name).to eql("Kirk,James")
    expect(ot.rank).to eql("SgtDet")
    expect(ot.assigned).to eql("A-1 DCU SQUAD")
    expect(ot.charged).to eql("A-1 DCU SQUAD")
    expect(ot.date).to eql("2014-01-02")
    expect(ot.code).to eql(280)
    expect(ot.description).to eql("COURT:TRIAL")
    expect(ot.start_time).to eql("0830")
    expect(ot.end_time).to eql("1030")
    expect(ot.worked_hours).to eql(2)
    expect(ot.ot_hours).to eql(4)
    expect(ot.officer).to eql(officer_kirk)
    expect(ot.attributions).to eql([attribution])
  end
end

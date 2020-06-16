describe Importer::BpdIaData do
  let(:record) {{
    :ia_no=>"401",
    :case_no=>"4192",
    :incident_type=>"Internal investigation",
    :received_date=>"1/2/2001",
    :first_name=>"James T",
    :last_name=>"Kirk",
    :title=>"Police Officer",
    :badge_id_number=>"4528",
    :allegation=>"Neg.Duty/Unreasonable Judge",
    :finding=>"Sustained",
    :finding_date=>"6/29/2004"
  }}

  it "imports a record" do
    Importer::BpdIaData.import([record])
    c = Complaint.first
    expect(c.ia_number).to eql("401")
    expect(c.case_number).to eql(4192)
    expect(c.incident_type).to eql("Internal investigation")
    expect(c.received_date).to eql("2001-01-02")
    expect(c.complaint_officers.size).to eql(1)
    co = c.complaint_officers.first
    expect(co.name).to eql("Kirk,James T")
    expect(co.title).to eql("Police Officer")
    expect(co.badge).to eql("4528")
    expect(co.allegation).to eql("Neg.Duty/Unreasonable Judge")
    expect(co.finding).to eql("Sustained")
    expect(co.finding_date).to eql("2004-06-29")
  end

  it "updates a record" do
    c = Complaint.create({ia_number: "401"})
    Importer::BpdIaData.import([record])
    expect(c.reload.case_number).to eql(4192)
  end

  it "doesn't dup if record imported twice" do
    Importer::BpdIaData.import([record, record])
    expect(Complaint.count).to eql(1)
    expect(ComplaintOfficer.count).to eql(1)
  end
end

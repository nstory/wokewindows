describe Importer::OfficerIaLog do
  let(:record) {{
    :ia_no=>"IAD2014-0004",
    :date_received=>"2-Jan-14",
    :date_occurred=>"28-Dec-13",
    :involved_officers=>"Detective James T Kirk\n\nPtl Bones Mccoy",
    :allegations=>"Respectful Treatment",
    :summary=> "Complainant reported that on 12/28/13 two Boston Police plain clothes officers came to her house to effect and a",
    :incident_type=>"Citizen complaint",
    :completed_date=>""
  }}

  it "imports a record" do
    Importer::OfficerIaLog.import([record])
    c = Complaint.first
    expect(c.ia_number).to eql("IAD2014-0004")
    expect(c.received_date).to eql("2014-01-02")
    expect(c.occurred_date).to eql("2013-12-28")
    expect(c.incident_type).to eql("Citizen complaint")
    expect(c.complaint_officers.count).to eql(2)
    expect(ComplaintOfficer.where("name = 'Detective James T Kirk'")).to exist
    expect(ComplaintOfficer.where("name = 'Ptl Bones Mccoy'")).to exist
  end

  it "record with blank ia_no" do
    record[:ia_no] = ""
    Importer::OfficerIaLog.import([record])
    expect(Complaint.first.ia_number.blank?).to eql(false)
  end

  it "record with blank incident_type" do
    record[:incident_type] = ""
    Importer::OfficerIaLog.import([record])
    expect(Complaint.first.incident_type).to eql(nil)
  end
end

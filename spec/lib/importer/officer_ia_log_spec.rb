describe Importer::OfficerIaLog do
  include_context "importer"

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

  it "updates an existing complaint, but only summary and attribution" do
    c = Complaint.create!(ia_number: "IAD2014-0004")
    importer.import
    c.reload
    expect(c.received_date).to eql(nil)
    expect(c.occurred_date).to eql(nil)
    expect(c.incident_type).to eql(nil)
    expect(c.complaint_officers.count).to eql(0)
    expect(c.summary).to match(/^Complain.*and a$/)
    expect(c.attributions).to eql([attribution])
  end
end

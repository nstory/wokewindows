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
  let(:records) { [record] }
  let(:attribution) { Attribution.new(filename: "foo.csv", category: "bar") }
  let(:parser) { mock_parser(records, attribution) }
  let(:importer) { Importer::BpdIaData.new(parser) }

  it "imports a record" do
    importer.import
    c = Complaint.first
    expect(c.ia_number).to eql("401")
    expect(c.case_number).to eql(4192)
    expect(c.incident_type).to eql("Internal investigation")
    expect(c.received_date).to eql("2001-01-02")
    expect(c.complaint_officers.size).to eql(1)
    expect(c.attributions).to eql([attribution])
    co = c.complaint_officers.first
    expect(co.name).to eql("Kirk,James T")
    expect(co.title).to eql("Police Officer")
    expect(co.badge).to eql("4528")
    expect(co.allegation).to eql("Neg.Duty/Unreasonable Judge")
    expect(co.finding).to eql("Sustained")
    expect(co.finding_date).to eql("2004-06-29")
  end

  it "does not update a record that existing before import" do
    c = Complaint.create({ia_number: "401"})
    importer.import
    expect(c.reload.case_number).to eql(nil)
    expect(c.complaint_officers.size).to eql(0)
  end

  it "does add two complaint officers to a record" do
    record_b = record.dup
    record_b[:first_name] = "Bones"
    record_b[:last_name] = "McCoy"
    records.push(record_b)
    importer.import
    c = Complaint.first
    expect(c.complaint_officers.count).to eql(2)
  end

  describe "dup records" do
    let(:records) { [record, record] }
    it "doesn't dup if record imported twice" do
      importer.import
      expect(Complaint.count).to eql(1)
      expect(ComplaintOfficer.count).to eql(1)
      expect(Complaint.first.attributions.count).to eql(1)
    end
  end

  it "imports blank badge as null" do
    record[:badge_id_number] = ""
    importer.import
    expect(ComplaintOfficer.first.badge).to eql(nil)
  end
end

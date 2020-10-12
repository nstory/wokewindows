describe Populater::ComplaintOfficers do
  let!(:officer) { Officer.create(employee_id: 1234, hr_name: "Kirk,James T", badge: "00456") }
  let!(:complaint_officer) { ComplaintOfficer.new(badge: "789", name: "BMccoy,Bones") }
  let!(:complaint_officer_2) { ComplaintOfficer.new(badge: "456", name: "Kirk,James T") }
  let!(:complaint) { Complaint.create(ia_number: 101, complaint_officers: [complaint_officer, complaint_officer_2]) }

  it "populates" do
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end

  it "populates case insensitive" do
    officer.hr_name = "KIRK,JAMES t"
    officer.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end

  it "matches a cut-off name" do
    complaint_officer_2.name = "Coppinger,Michael Christophe"
    complaint_officer_2.save
    officer.hr_name = "Coppinger,Michael Christopher"
    officer.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end

  it "matches a non-abbreviated middle name" do
    complaint_officer_2.name = "Bell,Marlisa Ann"
    complaint_officer_2.save
    officer.hr_name = "Bell,Marlisa A."
    officer.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end

  it "matches a hard-coded name" do
    complaint_officer_2.name = "Ezekial,Jason"
    complaint_officer_2.save
    officer.employee_id = 11817
    officer.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end

  it "doesn't match Manning,Michael" do
    complaint_officer_2.name = "Manning,Michael"
    complaint_officer_2.officer = officer
    complaint_officer_2.save
    officer.hr_name = "Manning,Michael"
    officer.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(nil)
  end

  it "matches a 2014 data name" do
    complaint_officer_2.name = "Ptl James T T Kirk"
    complaint_officer_2.badge = nil
    complaint_officer_2.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end

  it "matches a name" do
    complaint_officer_2.name = "Sullivan-Venezia,James Michael"
    complaint_officer_2.save
    officer.hr_name = "Sullivan-Venezia,James Michael"
    officer.save
    Populater::ComplaintOfficers.populate
    expect(complaint_officer_2.reload.officer).to eql(officer)
  end
end

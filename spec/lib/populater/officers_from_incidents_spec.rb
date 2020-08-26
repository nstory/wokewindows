describe Populater::OfficersFromIncidents do
  let!(:incident) { Incident.create(incident_number: 1, officer_journal_name:  "014000  LOL ROFL") }
  let!(:incident2) { Incident.create(incident_number: 2, officer_journal_name:  "014000  LOL ROFL") }

  it "imports an officer" do
    Populater::OfficersFromIncidents.populate
    officer = Officer.last
    expect(officer.employee_id).to eql(14000)
    expect(officer.journal_name).to eql("LOL ROFL")
    expect(officer.active).to eql(true)
  end

  it "doesn't import twice" do
    Populater::OfficersFromIncidents.populate
    Populater::OfficersFromIncidents.populate
    expect(Officer.count).to eql(1)
  end

  it "adds a journal_name to an existing officer" do
    Officer.create({employee_id: 14000})
    Populater::OfficersFromIncidents.populate
    expect(Officer.find_by(employee_id: 14000).journal_name).to eql("LOL ROFL")
  end

  it "doesn't import an employee_id below 14000" do
    incident.officer_journal_name = "13999  LOL ROFL"
    incident.save
    incident2.officer_journal_name = "13999  LOL ROFL"
    incident2.save
    Populater::OfficersFromIncidents.populate
    expect(Officer.count).to eql(0)
  end

  it "doesn't import an employee_id with one match" do
    incident2.delete
    Populater::OfficersFromIncidents.populate
    expect(Officer.count).to eql(0)
  end

  it "chooses most popular if multiple names with same id" do
    Incident.create(incident_number: 3, officer_journal_name:  "014000  MOST POPULAR")
    Incident.create(incident_number: 4, officer_journal_name:  "014000  MOST POPULAR")
    Incident.create(incident_number: 5, officer_journal_name:  "014000  MOST POPULAR")
    Incident.create(incident_number: 6, officer_journal_name:  "014000  MOST POPULAR")
    Incident.create(incident_number: 7, officer_journal_name:  "014000  LOL ROFL")
    Populater::OfficersFromIncidents.populate
    expect(Officer.find_by(employee_id: 14000).journal_name).to eql("MOST POPULAR")
  end

  it "doesn't update an officer who already has a journal_name" do
    officer = Officer.create({employee_id: 14000, journal_name: "XXX"})
    Populater::OfficersFromIncidents.populate
    officer.reload
    expect(officer.journal_name).to eql("XXX")
    expect(officer.active).to eql(false)
  end
end

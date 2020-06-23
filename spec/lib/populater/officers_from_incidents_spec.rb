describe Populater::OfficersFromIncidents do
  let!(:incident) { Incident.create(incident_number: 1, officer_journal_name:  "01234  LOL ROFL") }

  it "imports an officer" do
    Populater::OfficersFromIncidents.populate
    expect(Officer.find_by(employee_id: 1234).journal_name).to eql("LOL ROFL")
  end

  it "doesn't import twice" do
    Populater::OfficersFromIncidents.populate
    Populater::OfficersFromIncidents.populate
    expect(Officer.count).to eql(1)
  end

  it "adds a journal_name to an existing officer" do
    Officer.create({employee_id: 1234})
    Populater::OfficersFromIncidents.populate
    expect(Officer.find_by(employee_id: 1234).journal_name).to eql("LOL ROFL")
  end

  it "chooses most popular if multiple names with same id" do
    Incident.create(incident_number: 2, officer_journal_name:  "01234  MOST POPULAR")
    Incident.create(incident_number: 3, officer_journal_name:  "01234  MOST POPULAR")
    Incident.create(incident_number: 4, officer_journal_name:  "01234  MOST POPULAR")
    Incident.create(incident_number: 5, officer_journal_name:  "01234  LOL ROFL")
    Populater::OfficersFromIncidents.populate
    expect(Officer.find_by(employee_id: 1234).journal_name).to eql("MOST POPULAR")
  end
end

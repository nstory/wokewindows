describe Populater::IncidentOfficers do
  let!(:incident) { Incident.create(incident_number: 1, officer_journal_name: "4242  LOL ROFL") }
  let!(:officer) { Officer.create(employee_id: 4242, journal_name: "LOL ROFL") }

  it "associates" do
    Populater::IncidentOfficers.populate
    expect(officer.incidents.to_a).to eql([incident])
    expect(incident.reload.officer).to eql(officer)
  end

  it "doesn't associate if wrong" do
    incident.officer_journal_name = "4242  XOX ROFL"
    incident.save
    Populater::IncidentOfficers.populate
    expect(officer.incidents.to_a).to eql([])
  end

  it "is okay if officer doesn't exist" do
    officer.delete
    Populater::IncidentOfficers.populate
  end
end

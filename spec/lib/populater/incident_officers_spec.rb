describe Populater::IncidentOfficers do
  def create_incident_officer(journal_officer, number)
    Incident.create!({
      incident_number: number,
      incident_officers: [
        IncidentOfficer.new({
          journal_officer: journal_officer
        })
      ]
    })
  end

  it "associates" do
    inc = create_incident_officer("4242  LOL ROFL", 1)
    off = Officer.create(employee_id: 4242, journal_name: "LOL ROFL")
    Populater::IncidentOfficers.populate
    expect(off.incidents.to_a).to eql([inc])
  end

  it "doesn't associate if wrong" do
    create_incident_officer("4242  XOX ROFL", 1)
    off = Officer.create(employee_id: 4242, journal_name: "LOL ROFL")
    Populater::IncidentOfficers.populate
    expect(off.incidents.to_a).to eql([])
  end

  it "is okay if officer doesn't exist" do
    create_incident_officer("4242  LOL ROFL", 1)
    Populater::IncidentOfficers.populate
  end
end

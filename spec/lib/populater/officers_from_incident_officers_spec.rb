describe Populater::OfficersFromIncidentOfficers do
  def create_incident_officer(journal_officer, number)
    Incident.create({
      incident_number: number,
      incident_officers: [
        IncidentOfficer.create({
          journal_officer: journal_officer
        })
      ]
    })
  end

  before do
    create_incident_officer( "01234  LOL ROFL", 1)
  end

  it "imports an officer" do
    Populater::OfficersFromIncidentOfficers.populate
    expect(Officer.find_by(employee_id: 1234).journal_name).to eql("LOL ROFL")
  end

  it "doesn't import twice" do
    Populater::OfficersFromIncidentOfficers.populate
    Populater::OfficersFromIncidentOfficers.populate
    expect(Officer.count).to eql(1)
  end

  it "adds a journal_name to an existing officer" do
    Officer.create({employee_id: 1234})
    Populater::OfficersFromIncidentOfficers.populate
    expect(Officer.find_by(employee_id: 1234).journal_name).to eql("LOL ROFL")
  end

  it "chooses most popular if multiple names with same id" do
    create_incident_officer( "01234  MOST POPULAR", 2)
    create_incident_officer( "01234  MOST POPULAR", 3)
    create_incident_officer( "01234  MOST POPULAR", 4)
    create_incident_officer( "01234  LOL ROFL", 5)
    Populater::OfficersFromIncidentOfficers.populate
    expect(Officer.find_by(employee_id: 1234).journal_name).to eql("MOST POPULAR")
  end
end

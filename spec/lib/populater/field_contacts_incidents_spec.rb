describe Populater::FieldContactsIncidents do
  let!(:incident) { Incident.create(incident_number: 123456789) }
  let!(:field_contact) { FieldContact.create(fc_num: "FC123", narrative: "foo\n\nbar whatever I123456789 lol") }

  it "populates" do
    Populater::FieldContactsIncidents.populate
    expect(incident.field_contacts.to_a).to eql([field_contact])
    expect(field_contact.incidents.to_a).to eql([incident])
  end

  it "doesn't duplicate" do
    Populater::FieldContactsIncidents.populate
    Populater::FieldContactsIncidents.populate
    expect(incident.field_contacts.to_a).to eql([field_contact])
    expect(field_contact.incidents.to_a).to eql([incident])
  end
end

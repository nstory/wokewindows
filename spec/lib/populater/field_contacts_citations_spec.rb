describe Populater::FieldContactsCitations do
  let!(:citation) { Citation.create(ticket_number: "T1234567") }
  let!(:field_contact) { FieldContact.create(fc_num: "FC123", narrative: "foo\n\nbar whatever T1234567 lol") }

  it "populates" do
    Populater::FieldContactsCitations.populate
    expect(citation.field_contacts.to_a).to eql([field_contact])
    expect(field_contact.citations.to_a).to eql([citation])
  end
end

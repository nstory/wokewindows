describe Populater::FieldContactOfficers do
  let!(:officer) { Officer.create(employee_id: 123) }
  let!(:supervisor) { Officer.create(employee_id: 789) }
  let!(:field_contact) do
    FieldContact.create(
      fc_num: 456,
      contact_officer_employee_id: 123,
      supervisor_employee_id: 789
    )
  end

  it "populates contact_officer and supervisor" do
    Populater::FieldContactOfficers.populate
    expect(field_contact.reload.contact_officer).to eql(officer)
    expect(field_contact.supervisor).to eql(supervisor)
  end
end

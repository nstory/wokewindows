class CreateFieldContactsIncidentsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :field_contacts, :incidents do |t|
      # need to use custom name b/c rails generated name is above postgres limit of 63 chars
      t.index [:field_contact_id, :incident_id], name: "index_fc_incidents_on_field_contact_id_and_incident_id"
      t.index [:incident_id, :field_contact_id], unique: true, name: "index_fc_incidents_on_incident_id_and_field_contact_id"
    end
  end
end

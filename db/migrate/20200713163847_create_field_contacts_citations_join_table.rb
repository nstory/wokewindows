class CreateFieldContactsCitationsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :field_contacts, :citations do |t|
      t.index [:field_contact_id, :citation_id], name: "index_cfc_on_field_contact_id_and_citation_id"
      t.index [:citation_id, :field_contact_id], unique: true, name: "index_cfc_on_citation_id_and_field_contact_id"
    end
  end
end

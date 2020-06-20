class AddAttributionsToComplaint < ActiveRecord::Migration[6.0]
  def change
    add_column :complaints, :attributions, :text
    add_column :incidents, :attributions, :text
    add_column :field_contacts, :attributions, :text
    add_column :field_contact_names, :attributions, :text
    add_column :compensations, :attributions, :text
    add_column :officers, :attributions, :text
  end
end

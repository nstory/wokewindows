class AddFieldContactNamesCountToFieldContacts < ActiveRecord::Migration[6.0]
  def self.up
    add_column :field_contacts, :field_contact_names_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :field_contacts, :field_contact_names_count
  end
end

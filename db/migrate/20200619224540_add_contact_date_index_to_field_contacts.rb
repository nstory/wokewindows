class AddContactDateIndexToFieldContacts < ActiveRecord::Migration[6.0]
  def change
    add_index :field_contacts, :contact_date
  end
end

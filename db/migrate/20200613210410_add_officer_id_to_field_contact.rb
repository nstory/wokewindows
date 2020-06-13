class AddOfficerIdToFieldContact < ActiveRecord::Migration[6.0]
  def change
    change_table :field_contacts do |t|
      t.references :contact_officer
      t.references :supervisor
    end
  end
end

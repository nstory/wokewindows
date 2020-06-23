class AddOfficerToIncident < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :incidents, :officer
    add_column :incidents, :officer_journal_name, :string
    drop_table :incident_officers
  end
end

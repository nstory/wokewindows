class ChangeIncidentNumberColumnOnIncident < ActiveRecord::Migration[6.0]
  def change
    remove_column :incidents, :incident_number
    add_column :incidents, :incident_number, :integer
    add_index :incidents, :incident_number, unique: true
  end
end

class AddNibrsColumnsToIncidents < ActiveRecord::Migration[6.0]
  def change
    add_column :incidents, :nibrs_offenses, :jsonb, default: []
    add_column :incidents, :location_type, :string
    add_column :incidents, :incident_clearance, :string
    add_column :incidents, :exceptional_clearance_date, :string
    add_column :incidents, :number_of_victims, :integer
    add_column :incidents, :number_of_offenders, :integer
    add_column :incidents, :number_of_arrestees, :integer
  end
end

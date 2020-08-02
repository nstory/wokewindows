class AddReportedLocationFieldsToIncident < ActiveRecord::Migration[6.0]
  def change
    add_column :incidents, :reported_latitude, :float
    add_column :incidents, :reported_longitude, :float

    reversible do |dir|
      dir.up do
        execute 'UPDATE incidents SET reported_latitude = latitude'
        execute 'UPDATE incidents SET reported_longitude = longitude'
      end
    end
  end
end

class AddGeocodeLatLongToIncident < ActiveRecord::Migration[6.0]
  def change
    add_column :incidents, :geocode_latitude, :float
    add_column :incidents, :geocode_longitude, :float
  end
end

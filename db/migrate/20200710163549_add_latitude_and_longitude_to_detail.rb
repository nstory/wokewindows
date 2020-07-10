class AddLatitudeAndLongitudeToDetail < ActiveRecord::Migration[6.0]
  def change
    add_column :details, :latitude, :float
    add_column :details, :longitude, :float
  end
end

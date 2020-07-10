class CreateGeocodes < ActiveRecord::Migration[6.0]
  def change
    create_table :geocodes do |t|
      t.string :provider, null: false
      t.string :query, null: false
      t.float :latitude
      t.float :longitude
      t.timestamps

      t.index [:query, :provider], unique: true
    end
  end
end

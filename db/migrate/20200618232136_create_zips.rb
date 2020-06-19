class CreateZips < ActiveRecord::Migration[6.0]
  def change
    create_table :zip_codes do |t|
      t.integer :zip
      t.string :city
      t.string :state
      t.float :latitude
      t.float :longitude
      t.timestamps

      t.index :zip, unique: true
    end
  end
end

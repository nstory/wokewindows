class CreateForfeitures < ActiveRecord::Migration[6.0]
  def change
    create_table :forfeitures do |t|
      t.string :sucv
      t.decimal :amount
      t.string :date
      t.string :motor_vehicle
      t.text :attributions
      t.timestamps
      t.index :sucv, unique: true
    end
  end
end

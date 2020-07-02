class CreateCasesTable < ActiveRecord::Migration[6.0]
  include MigrationHelpers

  def change
    create_table :cases do |t|
      t.string :case_number
      t.string :court
      t.string :date
      t.decimal :amount
      t.string :motor_vehicle
      t.text :attributions
      t.timestamps

      t.index [:court, :case_number], unique: true
      t.index :case_number
      t.index :date
      t.index :amount
    end

    add_bag_of_text_column(:cases)

    create_table :cases_incidents do |t|
      t.integer :case_id, null: false
      t.integer :incident_id

      t.string :incident_number

      t.index :case_id
    end
  end
end

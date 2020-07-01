class CreateForfeitureIncidentsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_table :forfeitures_incidents do |t|
      t.string :incident_number
      t.integer :forfeiture_id, null: false
      t.integer :incident_id
      t.index [:forfeiture_id, :incident_id]
      t.index [:incident_id, :forfeiture_id]
    end
  end
end

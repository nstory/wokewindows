class CreateComplaints < ActiveRecord::Migration[6.0]
  def change
    create_table :complaints do |t|
      t.string :ia_number
      t.integer :case_number
      t.string :incident_type
      t.string :received_date

      t.index :ia_number, unique: true

      t.timestamps
    end
  end
end

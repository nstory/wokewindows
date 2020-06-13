class CreateFieldContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :field_contacts do |t|
      t.string :fc_num
      t.string :contact_date
      t.integer :contact_officer_employee_id
      t.string :contact_officer_name
      t.integer :supervisor_employee_id
      t.string :supervisor_name
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip

      # for frisked and various searched fields in pre-Sep data;
      # will need to be brought in from field_contact_names
      # for post-Sep data
      t.boolean :frisked_searched

      t.integer :stop_duration
      t.string :circumstance
      t.string :basis

      t.integer :vehicle_year
      t.string :vehicle_state
      t.string :vehicle_make
      t.string :vehicle_model
      t.string :vehicle_color
      t.string :vehicle_style
      t.string :vehicle_type

      t.text :key_situations # store as JSON; only in post-Sep data
      t.text :narrative
      t.string :weather

      t.timestamps

      t.index :fc_num, unique: true
    end
  end
end

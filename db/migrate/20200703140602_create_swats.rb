class CreateSwats < ActiveRecord::Migration[6.0]
  def change
    create_table :swats do |t|
      t.string :swat_number
      t.string :date
      t.text :attributions
      t.timestamps
      t.index :swat_number, unique: true
    end

    create_table :swats_officers do |t|
      t.integer :swat_id
      t.integer :officer_id
      t.string :officer_name
      t.timestamps
      t.index [:swat_id, :officer_id]
      t.index [:officer_id, :swat_id]
    end

    create_table :swats_incidents do |t|
      t.integer :swat_id
      t.integer :incident_id
      t.string :incident_number
      t.timestamps
      t.index [:swat_id, :incident_id]
      t.index [:incident_id, :swat_id]
    end

    add_column :officers, :swats_count, :integer, null: false, default: 0
  end
end

class CreateCitations < ActiveRecord::Migration[6.0]
  include MigrationHelpers

  def change
    create_table :citations do |t|
      t.integer :officer_id
      t.string :issuing_agency
      t.string :ticket_number
      t.integer :officer_number
      t.string :ticket_type
      t.string :source
      t.string :violator_type
      t.boolean :cdl
      t.string :license_class
      t.string :event_date
      t.integer :location_id
      t.string :location_name
      t.integer :posted_speed
      t.integer :violation_speed
      t.boolean :posted
      t.string :radar
      t.string :clocked
      t.string :race
      t.string :sex
      t.string :vehicle_color
      t.string :make
      t.integer :model_year
      t.boolean :sixteen_pass
      t.boolean :haz_mat
      t.decimal :amount
      t.boolean :paid
      t.boolean :hearing_requested
      t.string :court_code
      t.integer :age
      t.boolean :searched
      t.text :offenses
      t.text :attributions
      t.timestamps

      t.index :ticket_number, unique: true
      t.index :officer_id
      t.index :event_date
    end

    add_bag_of_text_column(:citations)
    add_column :officers, :citations_count, :integer, null: false, default: 0
  end
end

class CreateOvertimes < ActiveRecord::Migration[6.0]
  def change
    create_table :overtimes do |t|
      t.integer :employee_id
      t.integer :officer_id
      t.string :name
      t.string :rank
      t.string :assigned
      t.string :charged
      t.string :date
      t.integer :code
      t.string :description
      t.string :start_time
      t.string :end_time
      t.decimal :worked_hours
      t.decimal :ot_hours
      t.text :attributions
      t.timestamps

      t.index :officer_id
    end
  end
end

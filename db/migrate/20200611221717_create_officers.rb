class CreateOfficers < ActiveRecord::Migration[6.0]
  def change
    create_table :officers do |t|
      t.integer :employee_id
      t.string :journal_name

      t.index :employee_id, unique: true

      t.timestamps
    end
  end
end

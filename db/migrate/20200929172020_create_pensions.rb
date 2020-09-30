class CreatePensions < ActiveRecord::Migration[6.0]
  def change
    create_table :pensions do |t|
      t.string :name
      t.decimal :amount
      t.string :retirement_date
      t.string :department
      t.string :job_description
      t.integer :officer_id
      t.text :attributions
      t.timestamps
      t.index :officer_id, unique: true
    end
  end
end

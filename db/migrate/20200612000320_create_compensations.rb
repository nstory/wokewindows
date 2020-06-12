class CreateCompensations < ActiveRecord::Migration[6.0]
  def change
    create_table :compensations do |t|
      t.belongs_to :officer

      t.string :name
      t.string :department_name
      t.string :title
      t.decimal :regular
      t.decimal :retro
      t.decimal :other
      t.decimal :overtime
      t.decimal :injured
      t.decimal :detail
      t.decimal :quinn
      t.decimal :total
      t.integer :postal
      t.integer :year

      t.timestamps
    end
  end
end

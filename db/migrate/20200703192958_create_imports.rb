class CreateImports < ActiveRecord::Migration[6.0]
  def change
    create_table :imports do |t|
      t.string :name
      t.timestamps
      t.index :name, unique: true
    end
  end
end

class CreateOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :offenses do |t|
      t.belongs_to :incident
      t.integer :code
      t.string :code_group
      t.string :description

      t.timestamps
    end
  end
end

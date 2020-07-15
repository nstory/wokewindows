class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :url, null: false
      t.string :title
      t.text :admin_note
      t.text :body
      t.timestamps
      t.index :url, unique: true
    end
  end
end

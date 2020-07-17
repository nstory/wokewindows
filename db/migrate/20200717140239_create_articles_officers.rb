class CreateArticlesOfficers < ActiveRecord::Migration[6.0]
  def change
    create_table :articles_officers do |t|
      t.integer :officer_id
      t.integer :article_id
      t.string :status, default: "added", null: false

      t.index [:article_id, :officer_id], unique: true
      t.index [:officer_id, :status, :article_id]

      t.timestamps
    end

    add_column :officers, :articles_officers_count, :integer, null: false, default: 0
    add_column :articles, :date_published, :string
  end
end

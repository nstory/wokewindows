class AddConcerningToArticlesOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :articles_officers, :concerning, :boolean, default: false
  end
end

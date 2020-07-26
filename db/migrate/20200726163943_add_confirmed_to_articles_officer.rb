class AddConfirmedToArticlesOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :articles_officers, :confirmed, :boolean, default: false, null: false
  end
end

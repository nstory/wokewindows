class DropConfirmedFlagFromArticlesOfficer < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles_officers, :confirmed
  end
end

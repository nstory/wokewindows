class AddBadgeToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :badge, :string
  end
end

class AddActiveFlagToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :active, :boolean, null: false, default: false
  end
end

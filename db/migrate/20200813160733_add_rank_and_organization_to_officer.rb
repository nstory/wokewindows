class AddRankAndOrganizationToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :rank, :string, default: nil
    add_column :officers, :organization, :string, default: nil
  end
end

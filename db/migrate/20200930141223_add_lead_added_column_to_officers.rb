class AddLeadAddedColumnToOfficers < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :lead_added, :string
  end
end

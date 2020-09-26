class AddLeadInformationColumnToOfficers < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :lead_entry, :string, default: nil
  end
end

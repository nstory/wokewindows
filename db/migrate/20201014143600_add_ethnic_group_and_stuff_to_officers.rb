class AddEthnicGroupAndStuffToOfficers < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :start_date, :string
    add_column :officers, :sex, :string
    add_column :officers, :ethnic_group, :string
  end
end

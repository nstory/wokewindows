class AddFieldsToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :title, :string
    add_column :officers, :regular, :decimal
    add_column :officers, :retro, :decimal
    add_column :officers, :other, :decimal
    add_column :officers, :overtime, :decimal
    add_column :officers, :injured, :decimal
    add_column :officers, :detail, :decimal
    add_column :officers, :quinn, :decimal
    add_column :officers, :total, :decimal
    add_column :officers, :postal, :integer
    add_column :officers, :complaints_count, :integer, null: false, default: 0
  end
end

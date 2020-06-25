class AddIndexToOfficers < ActiveRecord::Migration[6.0]
  def change
    add_index :officers, :total
  end
end

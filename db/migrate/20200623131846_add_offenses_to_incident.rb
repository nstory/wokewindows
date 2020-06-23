class AddOffensesToIncident < ActiveRecord::Migration[6.0]
  def change
    add_column :incidents, :offenses, :jsonb, default: []
    drop_table :offenses
  end
end

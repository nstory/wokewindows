class AddArrestsToIncident < ActiveRecord::Migration[6.0]
  def change
    add_column :incidents, :arrests_json, :text
  end
end

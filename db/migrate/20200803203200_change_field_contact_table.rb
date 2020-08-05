class ChangeFieldContactTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :field_contacts, :stop_duration
    add_column :field_contacts, :stop_duration, :string, default: nil
    add_column :field_contacts, :search_vehicle, :boolean, default: nil
    add_column :field_contacts, :summons_issued, :boolean, default: nil
  end
end

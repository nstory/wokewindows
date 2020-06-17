class AddComplaintsCountFieldContactsCountIncidentsCountToOfficers < ActiveRecord::Migration[6.0]
  def self.up

    add_column :officers, :field_contacts_count, :integer, null: false, default: 0

    add_column :officers, :incidents_count, :integer, null: false, default: 0
  end

  def self.down

    remove_column :officers, :field_contacts_count

    remove_column :officers, :incidents_count
  end
end

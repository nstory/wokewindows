class AddGenderFieldToFieldContactName < ActiveRecord::Migration[6.0]
  def change
    add_column :field_contact_names, :gender, :string, default: nil
  end
end

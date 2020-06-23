class AddBagOfTextColumns < ActiveRecord::Migration[6.0]
  include MigrationHelpers

  def change
    add_bag_of_text_column :officers
    add_bag_of_text_column :field_contacts
    add_bag_of_text_column :complaints
  end
end

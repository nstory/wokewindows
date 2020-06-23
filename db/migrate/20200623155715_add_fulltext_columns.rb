class AddFulltextColumns < ActiveRecord::Migration[6.0]
  include MigrationHelpers

  def change
    enable_extension :pg_trgm
    add_bag_of_text_column(:incidents)
  end
end

module MigrationHelpers
  extend ActiveSupport::Concern

  def add_bag_of_text_column(table)
    add_column table, :bag_of_text, :text
    add_gin_index(table, :bag_of_text)
  end

  # https://github.com/jbox-web/ajax-datatables-rails#create-indices-for-postgresql-expert
  def add_gin_index(table, column)
      reversible do |dir|
        dir.up do
          execute "CREATE INDEX #{table}_#{column}_gin ON #{table} USING gin(#{column} gin_trgm_ops)"
        end
        dir.down do
          remove_index table.to_sym, name: "#{table}_#{column}_gin"
        end
      end
  end
end

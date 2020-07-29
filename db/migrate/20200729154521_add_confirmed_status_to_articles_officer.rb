class AddConfirmedStatusToArticlesOfficer < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        execute "UPDATE articles_officers SET status = 'confirmed' WHERE status = 'added' AND confirmed"
      end
      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end

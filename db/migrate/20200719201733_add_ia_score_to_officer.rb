class AddIaScoreToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :ia_score, :integer
  end
end

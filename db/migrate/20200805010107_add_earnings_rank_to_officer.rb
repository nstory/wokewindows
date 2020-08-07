class AddEarningsRankToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :earnings_rank, :integer, null: true
  end
end

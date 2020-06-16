class AddSummaryToComplaint < ActiveRecord::Migration[6.0]
  def change
    add_column :complaints, :summary, :string
  end
end

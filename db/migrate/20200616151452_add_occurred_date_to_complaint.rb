class AddOccurredDateToComplaint < ActiveRecord::Migration[6.0]
  def change
    add_column :complaints, :occurred_date, :string
  end
end

class AddIndexesToIncidents < ActiveRecord::Migration[6.0]
  def change
    add_index :incidents, :occurred_on_date
  end
end

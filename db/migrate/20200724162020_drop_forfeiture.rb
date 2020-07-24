class DropForfeiture < ActiveRecord::Migration[6.0]
  def change
    drop_table :forfeitures
    drop_table :forfeitures_incidents
  end
end

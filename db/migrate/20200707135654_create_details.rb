class CreateDetails < ActiveRecord::Migration[6.0]
  include MigrationHelpers

  def change
    create_table :details do |t|
      t.integer :officer_id
      t.integer :tracking_no
      t.integer :employee_number
      t.string :employee_name
      t.integer :employee_rank
      t.integer :customer_number
      t.string :customer_name
      t.string :street_no
      t.string :street
      t.string :xstreet
      t.string :start_date_time
      t.string :end_date_time
      t.integer :minutes_worked
      t.string :detail_type
      t.integer :pay_hours
      t.integer :pay_amount
      t.integer :pay_rate
      t.text :attributions
      t.timestamps

      t.index :tracking_no, unique: true
      t.index :start_date_time
      t.index :officer_id
    end

    add_bag_of_text_column(:details)

    add_column :officers, :details_count, :integer, null: false, default: 0
  end
end

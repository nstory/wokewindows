class CreateAppeals < ActiveRecord::Migration[6.0]
  include MigrationHelpers

  def change
    create_table :appeals do |t|
      t.string :case_type
      t.string :case_subtype
      t.string :status
      t.string :case_no, null: false
      t.string :appeal_no
      t.string :requester
      t.string :custodian
      t.string :req_rec_date
      t.string :resp_prov_date
      t.decimal :fees
      t.boolean :petitions
      t.string :comply
      t.string :date_opened
      t.string :date_closed
      t.string :reconsider_open_date
      t.string :reconsider_close_date
      t.string :in_cam_open_date
      t.string :in_cam_close_date
      t.boolean :request_to_court
      t.text :decisions_text
      t.text :decision_urls
      t.timestamps

      t.index :case_no, unique: true
      t.index :custodian
    end

    add_gin_index(:appeals, :decisions_text)
    add_gin_index(:appeals, :custodian)
  end
end

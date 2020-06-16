class CreateComplaintOfficers < ActiveRecord::Migration[6.0]
  def change
    create_table :complaint_officers do |t|
      t.belongs_to :complaint
      t.belongs_to :officer

      t.string :name
      t.string :title
      t.string :badge
      t.string :allegation
      t.string :finding
      t.string :finding_date

      t.timestamps
    end
  end
end

class CreateIncidentOfficers < ActiveRecord::Migration[6.0]
  def change
    create_table :incident_officers do |t|
      t.belongs_to :incident
      t.belongs_to :officer
      t.string :journal_officer

      t.timestamps
    end
  end
end

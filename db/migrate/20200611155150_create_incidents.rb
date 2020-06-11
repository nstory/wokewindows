class CreateIncidents < ActiveRecord::Migration[6.0]
  def change
    create_table :incidents do |t|
      # fields from crime_incident_report csv
      t.string :incident_number
      t.integer :offense_code
      t.string :offense_code_group
      t.string :offense_description
      t.string :district
      t.integer :reporting_area
      t.boolean :shooting
      t.datetime :occurred_on_date
      t.string :ucr_part
      t.string :street
      t.float :latitude
      t.float :longitude

      # fields from district journal
      t.datetime :report_date
      t.integer :officer_number
      t.string :officer_name
      t.string :location_of_occurrence
      t.string :nature_of_incident

      t.timestamps
    end
  end
end

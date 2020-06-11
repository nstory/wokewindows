class CreateIncidents < ActiveRecord::Migration[6.0]
  def change
    create_table :incidents do |t|
      # fields from crime_incident_report csv
      t.string :incident_number
      t.string :district
      t.integer :reporting_area
      t.boolean :shooting
      t.string :occurred_on_date
      t.string :ucr_part
      t.string :street
      t.float :latitude
      t.float :longitude

      # fields from district journal
      t.datetime :report_date
      t.text :location_of_occurrence # JSON array of strings
      t.text :nature_of_incident # JSON array of strings

      # need to be able to have multiple officers per incident
      # t.integer :officer_number
      # t.string :officer_name

      t.timestamps
    end
  end
end

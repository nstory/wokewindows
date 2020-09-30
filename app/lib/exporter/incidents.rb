class Exporter::Incidents < Exporter::Exporter
  def column_definitions
    column("incident_number") { record.incident_number }
    column("district") { record.district }
    column("reporting_area") { record.reporting_area }
    column("shooting") { record.shooting }
    column("occurred_on_date") { record.occurred_on_date }
    column("ucr_part") { record.ucr_part }
    column("street") { record.street }
    column("report_date") { record.report_date }
    column("location_of_occurrence") { write_array(record.location_of_occurrence) }
    column("nature_of_incident") { write_array(record.nature_of_incident) }
    column("officer_journal_name") { record.officer_journal_name }
    column("geocode_latitude") { record.geocode_latitude }
    column("geocode_longitude") { record.geocode_longitude }
    column("reported_latitude") { record.reported_latitude }
    column("reported_longitude") { record.reported_longitude }
    column("location_type") { record.location_type }
    column("incident_clearance") { record.incident_clearance }
    column("exceptional_clearance_date") { record.exceptional_clearance_date }
    column("number_of_victims") { record.number_of_victims }
    column("number_of_offenders") { record.number_of_offenders }
    column("number_of_arrestees") { record.number_of_arrestees }
    column("latitude") { record.latitude }
    column("longitude") { record.longitude }
    prefix("officer", Exporter::Officers) { record.officer }
  end

  def records
    Incident.includes(:officer, officer: [:pension, :zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]]).find_each
  end
end

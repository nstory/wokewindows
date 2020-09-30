class Exporter::FieldContacts < Exporter::Exporter
  def column_definitions
    column("fc_num") { record.fc_num }
    column("contact_date") { record.contact_date }
    column("contact_officer_employee_id") { record.contact_officer_employee_id }
    column("contact_officer_name") { record.contact_officer_name }
    column("supervisor_employee_id") { record.supervisor_employee_id }
    column("supervisor_name") { record.supervisor_name }
    column("street") { record.street }
    column("city") { record.city }
    column("state") { record.state }
    column("zip") { write_zip_code(record.zip) }
    column("frisked_searched") { write_boolean(record.frisked_searched) }
    column("circumstance") { record.circumstance }
    column("basis") { record.basis }
    column("vehicle_year") { record.vehicle_year }
    column("vehicle_state") { record.vehicle_state }
    column("vehicle_make") { record.vehicle_make }
    column("vehicle_model") { record.vehicle_model }
    column("vehicle_color") { record.vehicle_color }
    column("vehicle_style") { record.vehicle_style }
    column("vehicle_type") { record.vehicle_type }
    column("key_situations") { write_array(record.key_situations) }
    column("narrative") { record.narrative }
    column("weather") { record.weather }
    column("field_contact_names_count") { record.field_contact_names_count }
    column("stop_duration") { record.stop_duration }
    column("search_vehicle") { write_boolean(record.search_vehicle) }
    column("summons_issued") { write_boolean(record.summons_issued) }
    prefix("officer", Exporter::Officers) { record.contact_officer }
  end

  def records
    FieldContact.includes(:contact_officer, contact_officer: [:pension, :zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]])
  end
end

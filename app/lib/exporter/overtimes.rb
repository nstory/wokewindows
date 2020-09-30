class Exporter::Overtimes < Exporter::Exporter
  def column_definitions
    column("employee_id") { record.employee_id }
    column("name") { record.name }
    column("rank") { record.rank }
    column("assigned") { record.assigned }
    column("charged") { record.charged }
    column("date") { record.date }
    column("code") { record.code }
    column("description") { record.description }
    column("start_time") { record.start_time }
    column("end_time") { record.end_time }
    column("worked_hours") { record.worked_hours }
    column("ot_hours") { record.ot_hours }
    prefix("officer", Exporter::Officers) { record.officer }
  end

  def records
    Overtime.includes(:officer, officer: [:pension, :zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]]).find_each
  end
end

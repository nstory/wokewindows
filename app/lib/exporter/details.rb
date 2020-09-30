class Exporter::Details < Exporter::Exporter
  def column_definitions
    column("tracking_no") { record.tracking_no }
    column("employee_number") { record.employee_number }
    column("employee_name") { record.employee_name }
    column("employee_rank") { record.employee_rank }
    column("customer_number") { record.customer_number }
    column("customer_name") { record.customer_name }
    column("street_no") { record.street_no }
    column("street") { record.street }
    column("xstreet") { record.xstreet }
    column("start_date_time") { record.start_date_time }
    column("end_date_time") { record.end_date_time }
    column("minutes_worked") { record.minutes_worked }
    column("detail_type") { record.detail_type }
    column("pay_hours") { record.pay_hours }
    column("pay_amount") { write_money(record.pay_amount) }
    column("pay_rate") { write_money(record.pay_rate) }
    column("latitude") { record.latitude }
    column("longitude") { record.longitude }
    prefix("officer", Exporter::Officers) { record.officer }
  end

  def records
    Detail.includes(:officer, officer: [:pension, :zip_code, :complaint_officers, :complaints, complaint_officers: [:complaint]])
  end
end

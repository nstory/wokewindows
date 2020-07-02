class CaseDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      case_number: {source: "Case.case_number", searchable: false},
      court_name: {source: "Case.court", searchable: false},
      date: {source: "Case.date", searchable: false, nulls_last: true},
      amount: {source: "Case.amount", searchable: false},
      motor_vehicle: {source: "Case.motor_vehicle", searchable: false},
      cases_incidents: {source: "Case.cases_incidents", searchable: false, orderable: false},
      bag_of_text: {source: "Case.bag_of_text", searchable: true, orderable: false}
    }
  end

  def data_record(record)
    {
      url: case_url(record),
      case_number: record.case_number,
      court_name: record.court_name,
      date: record.date,
      amount: record.amount,
      motor_vehicle: record.motor_vehicle,
      cases_incidents: record.cases_incidents.map do |ci|
        {url: ci.incident && incident_url(ci.incident), incident_number: ci.incident_number}
      end
    }
  end

  def get_raw_records
    Case.includes(:cases_incidents).all
  end
end

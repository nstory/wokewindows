class ForfeitureDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      sucv: {source: "Forfeiture.sucv", cond: :eq},
      date: {source: "Forfeiture.date"},
      amount: {source: "Forfeiture.amount"},
      motor_vehicle: {source: "Forfeiture.motor_vehicle"},
      forfeitures_incidents: {source: "Forfeiture.forfeitures_incidents", searchable: false, orderable: false}
    }
  end

  def data_record(record)
    {
      url: forfeiture_url(record),
      sucv: record.sucv,
      date: record.date,
      amount: record.amount,
      motor_vehicle: record.motor_vehicle,
      forfeitures_incidents: record.forfeitures_incidents.map do |fi|
        {url: fi.incident && incident_url(fi.incident), incident_number: fi.incident_number}
      end
    }
  end

  def get_raw_records
    Forfeiture.includes(:forfeitures_incidents).all
  end
end

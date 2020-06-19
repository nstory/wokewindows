class FieldContactDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      fc_num: {source: "FieldContact.fc_num", cond: :eq},
      contact_date: {source: "FieldContact.contact_date"},
      contact_officer_name: {source: "FieldContact.contact_officer_name"},
      supervisor_name: {source: "FieldContact.supervisor_name"},
      street: {source: "FieldContact.street"},
      city: {source: "FieldContact.city"},
      state: {source: "FieldContact.state"},
      zip: {source: "FieldContact.zip", cond: :eq},
      frisked_searched: {source: "FieldContact.frisked_searched", searchable: false},
      stop_duration: {source: "FieldContact.stop_duration", searchable: false},
      circumstance: {source: "FieldContact.circumstance"},
      basis: {source: "FieldContact.basis"},
      vehicle_year: {source: "FieldContact.vehicle_year", cond: :eq},
      vehicle_state: {source: "FieldContact.vehicle_state"},
      vehicle_make: {source: "FieldContact.vehicle_make"},
      vehicle_model: {source: "FieldContact.vehicle_model"},
      vehicle_color: {source: "FieldContact.vehicle_color"},
      vehicle_style: {source: "FieldContact.vehicle_style"},
      vehicle_type: {source: "FieldContact.vehicle_type"},
      key_situations: {source: "FieldContact.key_situations"},
      narrative: {source: "FieldContact.narrative"},
      weather: {source: "FieldContact.weather"}
    }
  end

  def data
    records.map do |record|
      {
        url: field_contact_path(record),
        fc_num: record.fc_num,
        contact_date: record.contact_date,
        contact_officer_name: record.contact_officer_name,
        supervisor_name: record.supervisor_name,
        street: record.street,
        city: record.city,
        state: record.state,
        zip: record.zip,
        frisked_searched: record.frisked_searched,
        stop_duration: record.stop_duration,
        circumstance: record.circumstance,
        basis: record.basis,
        vehicle_year: record.vehicle_year,
        vehicle_state: record.vehicle_state,
        vehicle_make: record.vehicle_make,
        vehicle_model: record.vehicle_model,
        vehicle_color: record.vehicle_color,
        vehicle_style: record.vehicle_style,
        vehicle_type: record.vehicle_type,
        key_situations: record.key_situations,
        narrative: record.narrative,
        weather: record.weather
      }
    end
  end

  def get_raw_records
    FieldContact.all
  end
end

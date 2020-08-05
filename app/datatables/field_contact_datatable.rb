class FieldContactDatatable < ApplicationDatatable

  def view_columns
    @view_columns ||= {
      fc_num: {source: "FieldContact.fc_num", searchable: false},
      contact_date: {source: "FieldContact.contact_date", searchable: false},
      contact_officer_name: {source: "FieldContact.contact_officer_name", searchable: false},
      supervisor_name: {source: "FieldContact.supervisor_name", searchable: false},
      street: {source: "FieldContact.street", searchable: false},
      city: {source: "FieldContact.city", searchable: false},
      state: {source: "FieldContact.state", searchable: false},
      zip: {source: "FieldContact.zip", cond: :eq},
      frisked_searched: {source: "FieldContact.frisked_searched", searchable: false},
      search_vehicle: {source: "FieldContact.search_vehicle", searchable: false},
      stop_duration: {source: "FieldContact.stop_duration", searchable: false},
      circumstance: {source: "FieldContact.circumstance", searchable: false},
      basis: {source: "FieldContact.basis", searchable: false},
      vehicle_year: {source: "FieldContact.vehicle_year", cond: :eq},
      vehicle_state: {source: "FieldContact.vehicle_state", searchable: false},
      vehicle_make: {source: "FieldContact.vehicle_make", searchable: false},
      vehicle_model: {source: "FieldContact.vehicle_model", searchable: false},
      vehicle_color: {source: "FieldContact.vehicle_color", searchable: false},
      vehicle_style: {source: "FieldContact.vehicle_style", searchable: false},
      vehicle_type: {source: "FieldContact.vehicle_type", searchable: false},
      key_situations: {source: "FieldContact.key_situations", searchable: false},
      narrative: {source: "FieldContact.narrative", searchable: false},
      weather: {source: "FieldContact.weather", searchable: false},
      field_contact_names_count: {source: "FieldContact.field_contact_names_count", searchable: false},
      bag_of_text: {source: "FieldContact.bag_of_text", searchable: false, orderable: false}
    }
  end

  def data_record(record)
    {
      url: field_contact_url(record),
      fc_num: record.fc_num,
      contact_date: record.contact_date,
      contact_officer_name: record.contact_officer_name,
      supervisor_name: record.supervisor_name,
      street: record.street,
      city: record.city,
      state: record.state,
      zip: record.zip,
      frisked_searched: record.frisked_searched,
      search_vehicle: record.search_vehicle,
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
      weather: record.weather,
      field_contact_names_count: record.field_contact_names_count
    }
  end

  def get_raw_records
    q = FieldContact.all
    if params[:officer_id]
      q = q.where("contact_officer_id" => params[:officer_id])
    end
    q
  end
end

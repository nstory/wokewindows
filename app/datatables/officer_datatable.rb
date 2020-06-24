class OfficerDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      employee_id: {source: "Officer.employee_id", cond: :eq},
      name: {source: "Officer.hr_name", searchable: false},
      title: {source: "Officer.title", searchable: false},
      doa: {source: "Officer.doa", searchable: false},
      regular: {source: "Officer.regular", searchable: false, nulls_last: true},
      retro: {source: "Officer.retro", searchable: false, nulls_last: true},
      other: {source: "Officer.other", searchable: false, nulls_last: true},
      overtime: {source: "Officer.overtime", searchable: false, nulls_last: true},
      injured: {source: "Officer.injured", searchable: false, nulls_last: true},
      detail: {source: "Officer.detail", searchable: false, nulls_last: true},
      quinn: {source: "Officer.quinn", searchable: false, nulls_last: true},
      total: {source: "Officer.total", searchable: false, nulls_last: true},
      complaints_count: {source: "Officer.complaints_count", searchable: false},
      field_contacts_count: {source: "Officer.field_contacts_count", searchable: false},
      incidents_count: {source: "Officer.incidents_count", searchable: false},
      postal: {source: "Officer.postal", cond: :eq},
      state: {source: "ZipCode.state", searchable: false},
      city: {source: "ZipCode.city", searchable: false},
      bag_of_text: {source: "Officer.bag_of_text", searchable: true, orderable: false}
    }
  end

  def data
    records.map do |record|
      {
        url: officer_path(record),
        employee_id: record.employee_id,
        name: record.name,
        title: record.title,
        doa: record.doa,
        total: record.total,
        regular: record.regular,
        retro: record.retro,
        other: record.other,
        overtime: record.overtime,
        injured: record.injured,
        detail: record.detail,
        quinn: record.quinn,
        complaints_count: record.complaints_count,
        field_contacts_count: record.field_contacts_count,
        incidents_count: record.incidents_count,
        postal: record.postal,
        state: record.zip_code && record.zip_code.state,
        city: record.zip_code && record.zip_code.city
      }
    end
  end

  def get_raw_records
    Officer.includes(:compensations, :complaints, :zip_code).references(:zip_code).distinct
  end

end

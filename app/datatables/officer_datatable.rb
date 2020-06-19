class OfficerDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :officer_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      employee_id: {source: "Officer.employee_id", cond: :eq},
      name: {source: "Officer.hr_name", cond: :like},
      title: {source: "Officer.title"},
      doa: {source: "Officer.doa"},
      regular: {source: "Officer.regular", searchable: false},
      retro: {source: "Officer.retro", searchable: false},
      other: {source: "Officer.other", searchable: false},
      overtime: {source: "Officer.overtime", searchable: false},
      injured: {source: "Officer.injured", searchable: false},
      detail: {source: "Officer.detail", searchable: false},
      quinn: {source: "Officer.quinn", searchable: false},
      total: {source: "Officer.total", searchable: false},
      complaints_count: {source: "Officer.complaints_count", searchable: false},
      field_contacts_count: {source: "Officer.field_contacts_count", searchable: false},
      incidents_count: {source: "Officer.incidents_count", searchable: false},
      postal: {source: "Officer.postal", cond: :eq},
      state: {source: "ZipCode.state"},
      city: {source: "ZipCode.city"}
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
    # insert query here
    # User.all
    Officer.includes(:compensations, :complaints, :zip_code).joins(:zip_code).all
  end

end

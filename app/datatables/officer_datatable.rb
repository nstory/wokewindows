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
      title: {searchable: false, orderable: false},
      doa: {source: "Officer.doa"},
      total_earnings: {searchable: false, orderable: false},
      complaints_count: {searchable: false, orderable: false},
      field_contacts_count: {source: "Officer.field_contacts_count", searchable: false},
      incidents_count: {source: "Officer.incidents_count", searchable: false},
      zip_code: {searchable: false, orderable: false}
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
        total_earnings: record.total_earnings,
        complaints_count: record.complaints_count,
        field_contacts_count: record.field_contacts_count,
        incidents_count: record.incidents_count,
        zip_code: record.zip_code
      }
    end
  end

  def get_raw_records
    # insert query here
    # User.all
    Officer.includes(:compensations, :complaints).all
  end

end

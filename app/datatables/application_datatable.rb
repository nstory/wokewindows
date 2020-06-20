class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :officer_path, :incident_path, :field_contact_path, :complaint_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  # by default ajax-datatable-rails html encodes values; don't do that
  def sanitize_data(data)
    data
  end
end

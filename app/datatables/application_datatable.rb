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

  # this is mostly copy-and-pasted from the superclass; I added logic for
  # bag_of_text; if a :bag_of_text view_column is present, it will be searched
  def build_conditions_for_datatable
    criteria = search_for.inject([]) do |crit, atom|
      search = AjaxDatatablesRails::Datatable::SimpleSearch.new(value: atom, regex: datatable.search.regexp?)
      disjunction = searchable_columns.map do |simple_column|
        simple_column.search = search
        simple_column.search_query
      end.reduce(:or)
      bag_of_text_class = get_bag_of_text_class
      if bag_of_text_class
        disjunction = disjunction.or(bag_of_text_class.arel_table[:bag_of_text].matches("%#{atom}%"))
      end
      crit << disjunction
    end.compact.reduce(:and)
    criteria
  end

  private
  def get_bag_of_text_class
    source = view_columns.dig(:bag_of_text, :source)
    if source
      source.split(".").first.constantize
    else
      nil
    end
  end
end

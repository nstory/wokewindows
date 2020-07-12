require "csv"

class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :officer_url, :incident_url, :field_contact_url, :complaint_url, :case_url, :swat_url, :detail_url, :citation_url

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  # by default ajax-datatable-rails html encodes values; don't do that
  def sanitize_data(data)
    data
  end

  # my subclasses implement data_record instead of data
  def data
    records.map { |record| data_record(record) }
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
        bag_of_text_query = bag_of_text_class.arel_table[:bag_of_text].matches("%#{atom}%")
        if disjunction
          disjunction = disjunction.or(bag_of_text_query)
        else
          disjunction = bag_of_text_query
        end
      end
      crit << disjunction
    end.compact.reduce(:and)
    criteria
  end

  def write_csv(yielder)
    wrote_headers = false
    retrieve_records_for_csv.limit(10000).each do |record|
      data = data_record(record)
      if !wrote_headers
        wrote_headers = true
        yielder << CSV.generate_line(data.keys)
      end
      yielder << CSV.generate_line(map_csv_row(data.values))
    end
  end

  def map_csv_row(values)
    values.map do |v|
      v = v.join("; ") if v.respond_to?(:join)
      v
    end
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

  # this is retrieve_records copy-and-pasted from the superclass, but I
  # removed pagination b/c we don't want that for csv files
  def retrieve_records_for_csv
    records = fetch_records
    records = filter_records(records)
    records = sort_records(records) if datatable.orderable?
    records
  end
end

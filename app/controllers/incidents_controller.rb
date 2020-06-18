class IncidentsController < ApplicationController
  def index
    if request.format.symbol == :json
      @records_total = Incident.count
      query = Incident # apply_search(query)
      query = apply_search(query)
      query = query.includes(:incident_officers, :offenses)
      query = apply_order(query)
      @records_filtered = query.count
      query = apply_paging(query)
      @incidents = query
    end
  end

  private
  def apply_order(query)
    column_index = params.dig(:order, "0", "column")
    dir = params.dig(:order, "0", "dir")
    columns = {
      "1" => :occurred_on_date
    }
    column_name = columns[column_index]
    return query if !column_name
    query.order(column_name => (dir == "desc" ? :desc : :asc))
  end

  def apply_paging(query)
    start = params[:start]
    length = [params.fetch(:length, 100).to_i, 100].min
    query.offset(start).limit(length)
  end

  def apply_search(query)
    search = params.dig(:search, :value)
    return query if search.blank?
    ["street", "location_of_occurrence", "nature_of_incident", "district", "incident_number"].inject(query.where("1=0")) do |q,t|
      q.or(Incident.where("#{t} LIKE '%' || ? || '%'", search))
    end
  end
end

class IncidentsController < ApplicationController
  def datatable
    render json: IncidentDatatable.new(params, view_context: view_context)
  end

  def index
  end

  def show
    @incident = Incident.find_by incident_number: params[:id]
  end
end

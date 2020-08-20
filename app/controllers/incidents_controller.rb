class IncidentsController < ApplicationController
  include Datatableable

  def datatable_class
    IncidentDatatable
  end

  def index
  end

  def show
    @incident = Incident.find_by!(incident_number: params[:id])
  end
end

class CitationsController < ApplicationController
  include Datatableable

  def datatable_class
    CitationDatatable
  end

  def index
  end

  def show
    @citation = Citation.find_by!(ticket_number: params[:id])
  end
end

class DetailsController < ApplicationController
  include Datatableable

  def datatable_class
    DetailDatatable
  end

  def index
  end

  def show
    @detail = Detail.find_by!(tracking_no: params[:id])
  end
end

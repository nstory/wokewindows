class SwatsController < ApplicationController
  include Datatableable

  def datatable_class
    SwatDatatable
  end

  def index
  end

  def show
    @swat = Swat.find_by!(swat_number: params[:id])
  end
end

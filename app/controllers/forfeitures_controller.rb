class ForfeituresController < ApplicationController
  include Datatableable

  def datatable_class
    ForfeitureDatatable
  end

  def index
  end

  def show
    @forfeiture = Forfeiture.find_by!(sucv: params[:id])
  end
end

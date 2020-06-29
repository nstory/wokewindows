class OfficersController < ApplicationController
  include Datatableable

  def datatable_class
    OfficerDatatable
  end

  def index
  end

  def show
    @officer = Officer.includes(:compensations).find_by!(employee_id: params[:id])
    @attributions = [
      @officer.compensations.flat_map(&:attributions),
      @officer.attributions
    ].flatten.uniq
  end
end

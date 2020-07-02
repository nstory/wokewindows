class CasesController < ApplicationController
  include Datatableable

  def datatable_class
    CaseDatatable
  end

  def index
  end

  def show
    court, case_number = params[:id].split("-", 2)
    @case = Case.find_by!(court: court, case_number: case_number)
  end
end

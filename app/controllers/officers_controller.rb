class OfficersController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:datatable]

  def datatable
    render json: OfficerDatatable.new(params, view_context: view_context)
  end

  def show
    @officer = Officer.includes(:compensations).find_by(employee_id: params[:id])
  end
end

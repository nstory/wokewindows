class ComplaintsController < ApplicationController
  def datatable
    render json: ComplaintDatatable.new(params, view_context: view_context)
  end

  def index
  end

  def show
    @complaint = Complaint.find_by(ia_number: params[:id])
  end
end

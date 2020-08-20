class ComplaintsController < ApplicationController
  include Datatableable

  def datatable_class
    ComplaintDatatable
  end

  def index
  end

  def show
    @complaint = Complaint.find_by!(ia_number: params[:id])
  end
end

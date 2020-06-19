class FieldContactsController < ApplicationController
  def datatable
    render json: FieldContactDatatable.new(params, view_context: view_context)
  end

  def index
  end

  def show
    @field_contact = FieldContact.find_by(fc_num: params[:id])
  end
end

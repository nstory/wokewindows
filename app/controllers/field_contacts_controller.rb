class FieldContactsController < ApplicationController
  def datatable
    render json: FieldContactDatatable.new(params, view_context: view_context)
  end

  def index
  end

  def show
    @field_contact = FieldContact.find_by(fc_num: params[:id])
    @attributions = [
      @field_contact.field_contact_names.flat_map(&:attributions).to_a,
      @field_contact.attributions.to_a
    ].flatten.uniq
  end
end

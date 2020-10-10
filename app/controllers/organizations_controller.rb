class OrganizationsController < ApplicationController
  include Datatableable

  def datatable_class
    OrganizationDatatable
  end

  def index
  end

  def show
    @organization_officers = Officer.where("organization ILIKE ?", params[:id].gsub("-", " "))
    raise ActiveRecord::RecordNotFound.new("Couldn't find Organization") if @organization_officers.length == 0
    org_param = params[:id].parameterize
    redirect_to organization_path(org_param), status: 301 if params[:id] != org_param
  end
end

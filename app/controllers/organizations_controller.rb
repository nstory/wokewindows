class OrganizationsController < ApplicationController
  def index
    @organizations = Officer.group(:organization).where.not(organization: nil).order("count(employee_id) desc").count
  end

  def show
    @organization = Officer.organization_from_param(params[:id])
    raise ActiveRecord::RecordNotFound if @organization == nil
    @officers = Officer.where(organization: @organization).order(ia_score: :desc)
    raise ActiveRecord::RecordNotFound if @officers.length == 0
  end
end

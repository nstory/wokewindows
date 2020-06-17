class OfficersController < ApplicationController
  def index
    @officers = Officer.includes(:compensations, :complaints).find_each
  end

  def show
    @officer = Officer.includes(:compensations).find_by(employee_id: params[:id])
  end
end

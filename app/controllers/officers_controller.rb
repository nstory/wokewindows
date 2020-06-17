class OfficersController < ApplicationController
  def index
    @officers = Officer.includes(:compensations, :complaints).find_each
  end
end

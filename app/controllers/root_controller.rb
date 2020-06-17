class RootController < ApplicationController
  def index
    @officers = Officer.includes(:compensations, :complaints, :field_contacts, :incidents).first(50)
  end
end

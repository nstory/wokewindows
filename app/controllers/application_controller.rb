class ApplicationController < ActionController::Base
  include Clearance::Controller
  if Rails.configuration.site_password
    http_basic_authenticate_with name: "anonymous", password: Rails.configuration.site_password
  end
end

class ApplicationController < ActionController::Base
  include Clearance::Controller
  before_action :redirect_to_preferred_hostname

  if Rails.configuration.site_password
    http_basic_authenticate_with name: "anonymous", password: Rails.configuration.site_password
  end

  def redirect_to_preferred_hostname
    p = Rails.configuration.preferred_host
    return unless p
    return if request.path == "/up"
    if request.host != p
      redirect_to request.url.sub(request.host, p), status: :moved_permanently
    end
  end
end

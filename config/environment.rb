# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# https://stackoverflow.com/a/48530150
Copsonrails::Application.default_url_options = Copsonrails::Application.config.action_mailer.default_url_options

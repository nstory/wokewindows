source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', '>= 1.4.2', require: false

gem 'origami', '~> 2.1.0'
gem 'chronic', '~> 0.10.2'
gem 'bootstrap', '~> 4.5.0'
gem 'counter_culture', '~> 2.5.1'
gem 'ajax-datatables-rails', '1.2.0'
gem 'high_voltage', '~> 3.1.2'
gem 'metainspector', '~> 5.10.0'
gem 'pg', '~> 1.2.3'
gem 'actionview-encoded_mail_to', '1.0.9'
gem 'aws-sdk-s3', '~> 1.72'
gem 'pry-rails', '~> 0.3.9' # yes, I want pry available in production too
gem 'rack-canonical-host', '~> 1.0.0'
gem 'geocoder', '1.6.3'
gem 'clearance', '~> 2.2.0'
gem 'httparty', '~> 0.18.1'
gem 'sitemap_generator', '6.1.2'
gem 'factory_bot_rails', '~> 6.1.0'
gem 'faraday', '~> 1.0.1'
gem 'redcarpet', '3.5.0'
gem 'active_attr', '0.15.0'
gem 'front_matter_parser', '0.2.1'
gem 'haversine', '0.3.2'
gem 'scoped_search', '~> 4.1.9'
gem 'kaminari', '~> 1.2.1'

# https://www.ruby-forum.com/t/i-am-using-ruby-version-2-3-8-and-rails-version-5-2-6-to-develop-my-application-since-yesterday-i-am-getting-the-error-i-tried-to-find-the-occurrence-of-this-nokogiri-html4-in-my-application-but-i-didnt-find-any-of-the-occurrence-like-this/263852/4 :shrug:
gem 'loofah', '~>2.19.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'dotenv-rails', '2.7.5'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'rspec-wait', '~> 0.0.9'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

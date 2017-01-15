# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgres as the database for Active Record
gem 'pg', '~> 0.19.0'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 0.4.0'

# Mock data
gem 'faker', '~> 1.6', '>= 1.6.6'

# Use GetYourRep to get rep info for address from Google Civic Information API and openstates.org
gem 'get_your_rep', '~> 1.0', '>= 1.0.4'

# PostGIS adapter for geospatial database modeling
gem 'activerecord-postgis-adapter', '~> 4.0', '>= 4.0.2'

# Use vPim for vCards
gem 'vpim', '~> 13.11', '>= 13.11.11'

# Use Rgeo::Shapefile to read and import shapefiles
gem 'rgeo-shapefile', '~> 0.4'

# Use rQRcode for QR codes
gem 'rqrcode', '~> 0.10.1'

# Use dragonfly for qr_code image processing
gem 'dragonfly', '~> 1.1.1'

gem 'figaro'
gem 'multi_json'
gem 'yajl-ruby'
gem 'jbuilder'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0'
  gem 'pry', '~> 0.10.4'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo filefs, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

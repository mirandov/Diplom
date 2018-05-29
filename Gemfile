source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.20.0'


# Use Thin as the application server
gem 'thin', '>= 1.6.0'
# gem 'unicorn'

# Use websockets
gem 'websocket-rails', '>= 0.7.0'
gem 'faye-websocket', '0.10.0' # fix for rails 4.2

# Use bunny for RabbitMQ access
gem 'bunny'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby


gem 'wkhtmltopdf-binary'
# Validate datetime fields
gem 'validates_timeliness', '~> 3.0'

# Need imagemagick! `sudo apt-get install imagemagick`
gem 'paperclip', '>= 4.2.0'

# Pdf generation
gem 'pdfkit'

# Rails console fix in production
gem 'rb-readline'

# Roles
gem 'bitmask_attributes'

# Versions
gem 'paper_trail'

# Safe delete
gem "paranoia", "~> 2.2"

# JSON compare
gem 'hashdiff'

# Multi-step forms
gem 'wicked'

# underscore.js
gem 'underscore-rails'





# Authentication and authorization
# Device authentication with CAS
gem 'devise'
gem 'devise_cas_authenticatable'

# authentication with CAS-server
gem 'rubycas-client'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.2'

# Use cancan for user roles
gem 'cancan'

# yaml to activerecord
gem 'active_hash'

# HTML and markup

# Use HAML for views
gem 'haml'      , '>= 4.0.0'
gem 'haml-rails', '>= 0.5', :group => :development

# Use simple form gem for simple form generation
gem 'simple_form'
# Use nested_form
gem 'nested_form'
gem 'enum_help'

# Use ransack for easy searching
gem 'ransack', '~> 1.8'

gem 'kaminari'

gem 'bootstrap-kaminari-views'

# CSS

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0' # sass-rails needs to be higher than 3.2 for bootstrap-sass (see below)

# Use Bootstrap 3 with Rails 4
gem 'bootstrap-sass', '~> 3.2.0'
gem 'bootstrap-multiselect-rails'

# JavaScript

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.4.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 3.1.0'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'js-cookie-rails', '~> 2.0.0.pre.beta.1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'

# Solves the Turbolinks problem with binds elements https://github.com/kossnocorp/jquery.turbolinks
gem 'jquery-turbolinks'

# Use Bootstrap Datepicker with Rails
#   and timepicker support
gem 'bootstrap-datepicker-rails', :github => 'pmtgroup/bootstrap-datepicker-rails', :branch => 'master'
# gem 'bootstrap-datepicker-rails', :require => 'bootstrap-datepicker-rails', :git => 'git://github.com/Nerian/bootstrap-datepicker-rails.git'
# Use flot: attractive JavaScript charts for jQuery


# Use jquery-tokeninput with rails
# gem 'jquery-tokeninput-rails', :github => 'progresspoint/jquery-tokeninput-rails', :tag => 'v1.7.0'
gem 'flot-rails', :git => "https://github.com/Kjarrigan/flot-rails.git"

# file upload buttons
gem 'bootstrap-filestyle-rails'

# List.JS
gem 'listjs-rails', '~> 1.1.1'

# Masked input
gem 'maskedinput-rails', '~> 1.4'

# Moment.js
gem 'momentjs-rails'

# Spin.js
gem 'spinjs-rails'

# jsPDF is a library for creating PDF files in client-side JavaScript
# gem 'jspdf-rails'

# Other

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.0.3'
gem 'config'

gem 'sidekiq', '< 5'
gem 'redis-namespace'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'awesome_print', require: 'ap'
  gem 'to_factory'
end



group :development do
  gem 'spring'
  gem 'quiet_assets'
end

group :development, :staging do
  gem 'binding_of_caller'
  gem 'better_errors'
end

group :development, :staging, :test do
  gem 'pry-rails'
end

group :test do
  gem 'database_cleaner', '>= 1.2.0'

  gem 'sham_rack', '~> 1.3.6'
  gem 'capybara',  '>= 2.2.1'
  gem 'timecop',   '~> 0.7.1'
  gem 'mocha',     '~> 1.0.0'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

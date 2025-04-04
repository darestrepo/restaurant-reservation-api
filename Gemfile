# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Code style
gem 'rubocop'
# Used for authentication
gem 'devise'
gem 'simple_token_authentication', '~> 1.0'
# Used for authotization
gem 'cancancan'
# AWS SDK for S3 file uploads
gem 'aws-sdk-s3', '~> 1.140'
# HTTP requests
gem 'httparty', '~> 0.21.0'
# API Documentation
gem 'rswag-api'
gem 'rswag-ui'
# CORS support
gem 'rack-cors'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec'
  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'dotenv-rails'
  # API Documentation spec helper
  gem 'rswag-specs'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

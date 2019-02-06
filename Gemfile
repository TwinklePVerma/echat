source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'carrierwave'
gem 'jbuilder', '~> 2.5'
gem 'puma', '~> 3.11'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2'
gem 'responders'
gem 'swagger-docs'

group :development, :test, :production do
  gem 'activerecord-reset-pk-sequence'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'coffee-rails', '~> 4.2'
  gem 'jquery-rails'
  gem 'rails-js'
  gem 'sass-rails', '~> 5.0'
  gem 'sqlite3'
  gem 'turbolinks', '~> 5'
  gem 'uglifier', '>= 1.3.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

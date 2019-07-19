# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.5"

gem "rails", "~> 6.0.0" # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem "aws-record" # An abstraction for Amazon DynamoDB https://github.com/aws/aws-sdk-ruby-record
gem "aws-sdk-ssm"
gem "dotenv-rails", "~> 2.7.5"
gem "lamby", require: false # Simple Rails & AWS Lambda Integration https://lamby.custominktech.com/
gem "sass-rails", "~> 5" # Use SCSS for stylesheets
gem "strip_attributes"
gem "turbolinks", "~> 5" # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "webpacker", "~> 4.0" # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

# gem "bootsnap", ">= 1.4.2", require: false # Reduces boot times through caching; required in config/boot.rb
# gem "puma", "~> 3.11" # Use Puma as the app server

group :development, :test do
  gem "awesome_print"
  gem "factory_bot_rails"
  gem "faker"
  gem "guard-minitest"
  gem "guard"
  gem "pry-byebug"
  gem "pry-rails"
  gem "pry"
  gem "rubocop-rails"
  gem "rubocop", require: false
  gem "terminal-notifier-guard"
end

group :development do
  gem "foreman", "0.63.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring" # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "web-console", ">= 3.3.0" # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
end

group :test do
  gem "capybara", ">= 2.15" # Adds support for Capybara system testing and selenium driver
  gem "minitest-rails"
  gem "minitest-reporters"
  gem "mocha" # Mocha is a mocking and stubbing library for Ruby https://mocha.jamesmead.org
  gem "ruby-prof" # https://github.com/guard/guard-minitest#rails-gem-dependencies
  gem "selenium-webdriver"
  gem "webdrivers" # Easy installation and use of web drivers to run system tests with browsers
end

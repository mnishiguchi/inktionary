# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Inktionary
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # http://guides.rubyonrails.org/generators.html
    config.generators do |g|
      g.orm false
      g.template_engine :erb
      g.test_framework :minitest, spec: false, fixture: true
      g.stylesheets false
      g.helper false
      g.jbuilder false
      g.fixture_replacement :factory_bot, dir: "test/factories"
    end

    # Adopted from https://github.com/customink/stockpile/blob/master/config/application.rb
    config.dynamodb_table_name_suffix =
      if Rails.env.test? && ENV["TRAVIS_BUILD_ID"]
        "#{Rails.env}_#{ENV['TRAVIS_BUILD_ID']}"
      elsif Rails.env.production?
        Rails.env.to_s
      else
        "#{Rails.env}_#{`whoami`.strip}"
      end
  end
end

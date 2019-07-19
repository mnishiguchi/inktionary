# frozen_string_literal: true

# Just use the production settings
# Adopted from: http://nts.strzibny.name/creating-staging-environments-in-rails/
require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  # Here override any defaults
end

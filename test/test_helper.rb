# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"
require "minitest/retry"
require "mocha/minitest"
require_relative "./support/dynamodb.rb"

Minitest::Reporters.use!
# This is useful because DynamoDB's eventual consistency can causes our test to fail.
Minitest::Retry.use!

# Consider setting MT_NO_EXPECTATIONS to not add expectations to Object.
# ENV["MT_NO_EXPECTATIONS"] = true

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods
end

# frozen_string_literal: true

require "vcr"

# https://github.com/titusfortner/webdrivers/wiki/Using-with-VCR-or-WebMock#vcr
driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.ignore_hosts(*driver_hosts)
  # c.default_cassette_options = { record: :new_episodes }
end

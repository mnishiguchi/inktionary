# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard "minitest", spring: "bin/rails test" do
  # Adopted from https://github.com/guard/guard-rspec#typical-rails-app
  watch("test/test_helper.rb")                        { "test" }
  watch("config/routes.rb")                           { "test/routing" }
  watch("app/controllers/application_controller.rb")  { "test/controllers" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
    ["test/routing/#{m[1]}_routing_test.rb",
     "test/#{m[2]}s/#{m[1]}_#{m[2]}_test.rb"]
  end
end

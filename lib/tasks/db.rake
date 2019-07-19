# frozen_string_literal: true

namespace :db do
  desc "Creates the DynamoDB table."
  task "create" => :environment do
    ApplicationTable.create_table
  end

  desc "Deletesthe DynamoDB table."
  task "delete" => :environment do
    ApplicationTable.delete_table
  end

  desc "Seeds the DynamoDB table."
  task "seed" => :environment do
    ApplicationTable.seed_table
  end

  desc "Describes the DynamoDB table."
  task "describe" => :environment do
    puts JSON.pretty_generate(ApplicationTable.describe_table.to_h)
  end
end

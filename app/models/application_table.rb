# frozen_string_literal: true

# DynamoDB table settings for this app.
# Our design decision is that we have only one dynamodb table for the entire app.
# https://github.com/aws/aws-sdk-ruby-record
# https://docs.aws.amazon.com/awssdkrubyrecord/api/Aws/Record.html
class ApplicationTable
  include Aws::Record

  set_table_name(
    [Rails.application.class.module_parent_name.underscore,
     Rails.application.config.dynamodb_table_name_suffix].join("_")
  )

  # Primary keys
  string_attr :item_id, hash_key: true # "Word#2019-07-23#1000"

  # Optional attributes
  string_attr :word_name
  string_attr :explanation
  string_attr :dictionary # "api#999978"
  string_attr :tags # "#api#tech", "#"
  integer_attr :vote_count # 123

  string_attr :abcd # "z"
  string_attr :word_id # "Word#2019-07-23#1000"
  string_attr :user_id # masa@example.com

  epoch_time_attr :updated_at

  # Global secondary indexes
  # https://docs.aws.amazon.com/awssdkrubyrecord/api/Aws/Record/SecondaryIndexes/SecondaryIndexesClassMethods.html
  global_secondary_index :gsi_abcd,
                         hash_key:   :abcd,
                         range_key:  :dictionary,
                         projection: { projection_type: "ALL" }

  global_secondary_index :gsi_word_id,
                         hash_key:   :word_id,
                         range_key:  :item_id,
                         projection: { projection_type: "ALL" }

  global_secondary_index :gsi_user_id,
                         hash_key:   :user_id,
                         range_key:  :item_id,
                         projection: { projection_type: "INCLUDE", non_key_attributes: ["word_id"] }

  class << self
    # https://docs.aws.amazon.com/awssdkrubyrecord/api/Aws/Record/TableConfig.html
    # https://github.com/aws/aws-sdk-ruby-record/blob/master/features/table_config/table_config.feature
    # https://github.com/customink/customer_db_client/blob/master/lib/customer_db_client/dynamodb.rb
    def table_config
      @table_config ||= Aws::Record::TableConfig.define do |t|
        # This block is evaludated by "instance_eval".
        # https://github.com/aws/aws-sdk-ruby-record/blob/master/lib/aws-record/record/table_config.rb#L162
        t.model_class ApplicationTable
        t.read_capacity_units(1) # up to 4KB per second per unit
        t.write_capacity_units(3) # up to 1KB per second per unit
        t.global_secondary_index(:gsi_word_id) do |i|
          i.read_capacity_units(1)
          i.write_capacity_units(1)
        end
        t.global_secondary_index(:gsi_user_id) do |i|
          i.read_capacity_units(1)
          i.write_capacity_units(3)
        end
        t.global_secondary_index(:gsi_abcd) do |i|
          i.read_capacity_units(1)
          i.write_capacity_units(3)
        end
        # https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
        t.client_options(
          {
            logger: Rails.logger,
            region: "us-east-1"
          }.tap do |opts|
            # Production uses AWS IAM Roles, not keys or env vars
            if Rails.env.development? || Rails.env.test?
              opts.merge!(
                access_key_id:     "fake_key_id_for_dev",
                secret_access_key: "fake_secret_access_key_for_dev",
                endpoint:          "http://localhost:8000"
              )
            end
          end
        )
      end
    end

    # Override super's behavior because super only uses default client for dynamodb-local.
    # https://github.com/aws/aws-sdk-ruby-record/blob/master/lib/aws-record/record.rb#L183
    def dynamodb_client
      table_config.client
    end

    # https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
    def describe_table
      dynamodb_client.describe_table(table_name: table_name)
    end

    # Returns false if it is not up for any reason.
    def up?
      describe_table.present?
    rescue StandardError
      false
    end

    def create_table
      raise "Prohibitted in production" if Rails.env.production?

      # The compatiblitily check provides a helpful error message in case
      # something is wrong in the config.
      table_config.migrate! unless table_config.compatible?
    end

    def delete_table
      raise "Prohibitted in production" if Rails.env.production?

      dynamodb_client.delete_table(table_name: table_name)
    end

    def seed_table
      raise "Prohibitted in production" if Rails.env.production?

      load Rails.root.join("db", "seeds.rb").to_s
    end

    # TODO: Write the updater using "table_config.client", not AWS::Record's dynamodb_client
    # OR get dynamodb_client working.
    def create_item(attributes, opts)
      new.update!(attributes, opts)
    end
  end
end

# frozen_string_literal: true

require "active_support/concern"

# https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
module ApplicationTableItem
  module DynamodbOperations
    module Default
      extend ActiveSupport::Concern

      included do
      end

      class_methods do
        def find(item_id:)
          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            key_condition_expression:    "item_id = :item_id",
            expression_attribute_values: {
              ":item_id" => item_id
            }
          )
        end

        def delete(item_id:)
          ApplicationTable.dynamodb_client.delete_item(
            table_name: ApplicationTable.table_name,
            key:        {
              item_id: item_id
            }
          )
        end

        def all_items_by_abcd(abcd)
          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_abcd",
            key_condition_expression:    "abcd = :abcd",
            expression_attribute_values: {
              ":abcd" => abcd.downcase
            }
          )
        end

        def all_items_by_substring(substring)
          substring = substring.downcase

          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_abcd",
            key_condition_expression:    "abcd = :abcd and begins_with(dictionary, :substring)",
            expression_attribute_values: {
              ":abcd"      => substring.first,
              ":substring" => substring
            }
          )
        end

        def all_items_by_user_id(user_id)
          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_user_id",
            key_condition_expression:    "user_id = :user_id",
            expression_attribute_values: {
              ":user_id" => user_id
            }
          )
        end

        def all_items_by_word_id(word_id)
          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_word_id",
            key_condition_expression:    "word_id = :word_id",
            expression_attribute_values: {
              ":word_id" => word_id
            }
          )
        end
      end
    end
  end
end

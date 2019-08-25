# frozen_string_literal: true

require "active_support/concern"

# https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
module DynamodbOperations
  module Vote
    extend ActiveSupport::Concern

    ITEM_TYPE = "Vote"

    class_methods do
      def exist?(*args)
        find_by_user_id_and_word_id(*args).count.positive?
      end

      def where(user_id: nil, word_id: nil)
        if user_id && word_id
          find_by_user_id_and_word_id(user_id: user_id, word_id: word_id)
        elsif word_id
          find_by_word_id(word_id)
        elsif user_id
          find_by_user_id(user_id)
        else
          raise ArgumentError
        end
      end

      def find_by_user_id_and_word_id(user_id:, word_id:)
        ApplicationTable.dynamodb_client.query(
          table_name:                  ApplicationTable.table_name,
          index_name:                  "gsi_word_id",
          key_condition_expression:    "word_id = :word_id and begins_with(item_id, :item_type)",
          filter_expression:           "begins_with(user_id, :user_id)",
          expression_attribute_values: {
            ":word_id"   => word_id,
            ":item_type" => ITEM_TYPE,
            ":user_id"   => user_id
          }
        )
      end

      def find_by_word_id(word_id)
        ApplicationTable.dynamodb_client.query(
          table_name:                  ApplicationTable.table_name,
          index_name:                  "gsi_word_id",
          key_condition_expression:    "word_id = :word_id and begins_with(item_id, :item_type)",
          expression_attribute_values: {
            ":word_id"   => word_id,
            ":item_type" => ITEM_TYPE
          }
        )
      end

      def find_by_user_id(user_id)
        ApplicationTable.dynamodb_client.query(
          table_name:                  ApplicationTable.table_name,
          index_name:                  "gsi_user_id",
          key_condition_expression:    "user_id = :user_id and begins_with(item_id, :item_type)",
          expression_attribute_values: {
            ":user_id"   => user_id,
            ":item_type" => ITEM_TYPE
          }
        )
      end
    end
  end
end

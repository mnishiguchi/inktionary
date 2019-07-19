# frozen_string_literal: true

require "active_support/concern"

# https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
module ApplicationTableItem
  module DynamodbOperations
    module Tag
      extend ActiveSupport::Concern

      ITEM_TYPE = "Tag"

      included do
      end

      class_methods do
        def exist?(*args)
          find_by_word_id_and_tag_name(*args).count.positive?
        end

        def where(word_id: nil, tag_name: nil)
          if word_id && tag_name
            find_by_word_id_and_tag_name(word_id: word_id, tag_name: tag_name)
          elsif word_id
            find_by_word_id(word_id)
          elsif tag_name
            search(tag_name)
          else
            raise ArgumentError
          end
        end

        def find_by_word_id_and_tag_name(word_id:, tag_name:)
          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_word_id",
            key_condition_expression:    "word_id = :word_id and begins_with(item_id, :item_type)",
            filter_expression:           "word_name = :tag_name",
            expression_attribute_values: {
              ":word_id"   => word_id,
              ":item_type" => ITEM_TYPE,
              ":tag_name"  => tag_name
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

        def search(substring)
          raise ArgumentError if substring.blank?

          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_abcd",
            key_condition_expression:    "abcd = :abcd and begins_with(dictionary, :substring)",
            filter_expression:           "begins_with(item_id, :item_type)",
            expression_attribute_values: {
              ":abcd"      => substring.first.downcase,
              ":item_type" => ITEM_TYPE,
              ":substring" => substring.downcase
            }
          )
        end
      end
    end
  end
end

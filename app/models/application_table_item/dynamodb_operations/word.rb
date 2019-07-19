# frozen_string_literal: true

# https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
module ApplicationTableItem
  module DynamodbOperations
    module Word
      extend ActiveSupport::Concern

      ITEM_TYPE = "Word"

      included do
      end

      class_methods do
        def where(user_id: nil, abcd: nil, word_name: nil)
          if abcd
            find_by_abcd(abcd)
          elsif user_id
            find_by_user_id(user_id)
          elsif word_name
            search(word_name)
          else
            raise ArgumentError
          end
        end

        def find_by_abcd(abcd)
          raise ArgumentError if abcd.blank?

          ApplicationTable.dynamodb_client.query(
            table_name:                  ApplicationTable.table_name,
            index_name:                  "gsi_abcd",
            key_condition_expression:    "abcd = :abcd",
            filter_expression:           "begins_with(item_id, :item_type)",
            expression_attribute_values: {
              ":abcd"      => abcd.to_s.downcase,
              ":item_type" => ITEM_TYPE
            }
          )
        end

        def find_by_user_id(user_id)
          raise ArgumentError if user_id.blank?

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

        def update_vote_count(word_id:, vote_count:, dictionary:)
          raise ArgumentError unless word_id.present? && vote_count.is_a?(Numeric) && dictionary.present?

          ApplicationTable.dynamodb_client.update_item(
            table_name:        ApplicationTable.table_name,
            key:               {
              item_id: word_id
            },
            return_values:     "ALL_NEW",
            attribute_updates: {
              vote_count: { action: "PUT", value: vote_count },
              dictionary: { action: "PUT", value: dictionary }
            }
          )
        end

        def update_tags(word_id:, tags:)
          raise ArgumentError if word_id.blank? || tags.blank?

          ApplicationTable.dynamodb_client.update_item(
            table_name:        ApplicationTable.table_name,
            key:               {
              item_id: word_id
            },
            return_values:     "ALL_NEW",
            attribute_updates: {
              tags: { action: "PUT", value: tags }
            }
          )
        end
      end
    end
  end
end

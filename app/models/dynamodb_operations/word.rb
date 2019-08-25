# frozen_string_literal: true

# https://docs.aws.amazon.com/sdkforruby/api/Aws/DynamoDB/Client.html
module DynamodbOperations
  module Word
    extend ActiveSupport::Concern

    ITEM_TYPE = "Word"

    included do
      def update
        super(updatable_keys: %w[word_name explanation dictionary abcd updated_at])
      end

      # Fetch current vote count from dynamodb and update word item with that value.
      def sync_vote_count
        self.vote_count = ::Vote.where(word_id: item_id).count
        validate!
        ApplicationTable.dynamodb_client.update_item(
          table_name:        ApplicationTable.table_name,
          key:               {
            item_id: item_id
          },
          return_values:     "ALL_NEW",
          attribute_updates: {
            vote_count: { action: "PUT", value: vote_count },
            dictionary: { action: "PUT", value: dictionary }
          }
        )
      end

      def sync_tags
        self.tags = ::Tag.tag_list(word_id: item_id)
        validate!
        ApplicationTable.dynamodb_client.update_item(
          table_name:        ApplicationTable.table_name,
          key:               {
            item_id: item_id
          },
          return_values:     "ALL_NEW",
          attribute_updates: {
            tags: { action: "PUT", value: tags }
          }
        )
      end
    end

    class_methods do
      def where(user_id: nil, abcd: nil, word_name: nil, tag_name: nil)
        if abcd
          find_by_abcd(abcd)
        elsif user_id
          find_by_user_id(user_id)
        elsif word_name
          search(word_name)
        elsif tag_name
          find_by_tag_name(tag_name)
        else
          raise ArgumentError
        end
      end

      def find_by_abcd(abcd)
        return [] if abcd.blank?

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
        return [] if user_id.blank?

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

      def find_by_tag_name(tag_name)
        return [] if tag_name.blank?

        ApplicationTable.dynamodb_client.scan(
          table_name:                  ApplicationTable.table_name,
          index_name:                  "gsi_abcd",
          filter_expression:           "begins_with(item_id, :item_type) and contains(tags, :tag_name)",
          expression_attribute_values: {
            ":item_type" => ITEM_TYPE,
            ":tag_name"  => tag_name
          }
        )
      end

      def search(substring)
        return [] if substring.blank?

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

      def all
        ApplicationTable.dynamodb_client.scan(
          table_name:                  ApplicationTable.table_name,
          index_name:                  "gsi_abcd",
          filter_expression:           "begins_with(item_id, :item_type)",
          expression_attribute_values: {
            ":item_type" => ITEM_TYPE
          }
        )
      end

      def pluck_popular_items
        all.items.sort_by { |item| item.fetch("vote_count") }.reverse
      end

      def pluck_authors
        ApplicationTable.dynamodb_client.scan(
          table_name:                  ApplicationTable.table_name,
          index_name:                  "gsi_user_id",
          filter_expression:           "begins_with(item_id, :item_type)",
          expression_attribute_values: {
            ":item_type" => ITEM_TYPE
          }
        ).items
      end

      def pluck_word_names
        all.items.map { |x| x.fetch("word_name") }.uniq
      end
    end
  end
end

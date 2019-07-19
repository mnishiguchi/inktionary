# frozen_string_literal: true

# Common logic for our DynamoDB items.
# ApplicationTableItem defines and validates keys and attributes for a dynamodb item
module ApplicationTableItem
  class Base
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/model.rb
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/attributes.rb
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/type.rb
    include ActiveModel
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    include ApplicationTableItem::DynamodbOperations::Default

    ITEM_ID_REGEX = /\A(Word|Vote|Tag)#\d{4}-\d{2}-\d{2}#.{4}\z/.freeze
    WORD_ID_REGEX = /\A(Word)#\d{4}-\d{2}-\d{2}#.{4}\z/.freeze
    TAGS_REGEX = /#.*/.freeze
    WORD_DICTIONARY_REGEX = /\A[a-z_]*#\d{6}#.{4}\z/.freeze
    TAG_DICTIONARY_REGEX = /\A[a-z_]*\z/.freeze
    ABCD_REGEX = /\A[a-z]\z/.freeze

    # Performs put_item or update_item if item is valid
    # https://docs.aws.amazon.com/awssdkrubyrecord/api/Aws/Record/DynamodbOperations.html#save-instance_method
    def save(opts = {})
      validate!
      ApplicationTable.create_item(attributes, opts)
    end

    def assign_item_id
      self.item_id ||= [
        self.class.to_s,
        Date.current,
        SecureRandom.alphanumeric(4)
      ].join("#")
    end

    def assign_timestamps
      self.updated_at = Time.current
    end

    class << self
      def from_hash(hsh)
        new.tap { |w| w.assign_attributes(hsh) }
      end

      def create(hsh)
        from_hash(hsh).save
      end

      def underscore_string(value)
        return if value.blank?

        value.gsub(/[^0-9a-z ]/i, "").squish.underscore.tr(" ", "_")
      end
    end
  end
end

# frozen_string_literal: true

# Represents a word vote item in DynamoDB table.
class Vote < ApplicationTableItem::Base
  include ApplicationTableItem::DynamodbOperations::Vote

  # == Keys ==
  attribute :item_id, :string

  # == Attributes ==
  attribute :word_id, :string
  attribute :user_id, :string

  # == Pre-validation ==
  before_validation :assign_item_id

  # == Validation ==
  validates :item_id, format: { with: ITEM_ID_REGEX }
  validates :user_id, format: { with: URI::MailTo::EMAIL_REGEXP }
end

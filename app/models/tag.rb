# frozen_string_literal: true

# Represents a tag item in DynamoDB table.
class Tag < ApplicationTableItem::Base
  include ApplicationTableItem::DynamodbOperations::Tag

  # == Keys ==
  attribute :item_id, :string

  # == Attributes ==
  attribute :word_id, :string
  attribute :word_name, :string
  attribute :abcd, :string
  attribute :dictionary, :string

  # == Pre-validation ==
  before_validation :strip_word_name
  before_validation :assign_item_id
  before_validation :assign_dictionary
  before_validation :assign_abcd

  # == Validation ==
  validates :item_id, format: { with: ITEM_ID_REGEX }
  validates :abcd, format: { with: ABCD_REGEX }
  validates :word_name, length: { minimum: 1, maximum: 80 }
  validates :dictionary, format: { with: TAG_DICTIONARY_REGEX }

  private

  def strip_word_name
    self.word_name = StripAttributes.strip(word_name)
  end

  def assign_abcd
    self.abcd = word_name.presence&.first&.downcase
  end

  def assign_dictionary
    return if word_name.blank?

    self.dictionary = self.class.underscore_string(word_name)
  end

  class << self
    def tag_list(word_id:)
      Tag.where(word_id: word_id).items.map { |hsh| hsh["word_name"] }
    end
  end
end

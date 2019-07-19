# frozen_string_literal: true

# Represents a word item in DynamoDB table.
class Word < ApplicationTableItem::Base
  include ApplicationTableItem::DynamodbOperations::Word

  # == Keys ==
  attribute :item_id, :string

  # == Attributes ==
  attribute :user_id, :string
  attribute :abcd, :string
  attribute :word_name, :string
  attribute :dictionary, :string
  attribute :explanation, :string
  attribute :tags, :string
  attribute :vote_count, :integer
  attribute :updated_at, :time

  # == Pre-validation ==
  before_validation :strip_word_name
  before_validation :strip_explanation
  before_validation :assign_item_id
  before_validation :assign_dictionary
  before_validation :assign_tags
  before_validation :assign_abcd
  before_validation :assign_timestamps

  # == Validation ==
  validates :item_id, format: { with: ITEM_ID_REGEX }
  validates :user_id, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :abcd, format: { with: ABCD_REGEX }
  validates :word_name, length: { minimum: 1, maximum: 80 }
  validates :dictionary, format: { with: WORD_DICTIONARY_REGEX }
  validates :explanation, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :tags, format: { with: TAGS_REGEX }
  validates :vote_count, numericality: true
  validates :updated_at, presence: true

  def tags=(value)
    super(
      if value.blank?
        "#"
      elsif value.is_a?(Array)
        value.join("#").prepend("#")
      elsif value.is_a?(String)
        value
      end
    )
  end

  private

  def strip_word_name
    self.word_name = StripAttributes.strip(word_name)
  end

  def strip_explanation
    self.explanation = StripAttributes.strip(explanation)
  end

  def assign_word_id
    self.word_id = item_id
  end

  def assign_abcd
    self.abcd = word_name.presence&.first&.downcase
  end

  def assign_dictionary
    return if word_name.blank?

    self.dictionary = [
      self.class.underscore_string(word_name),
      score_for_sorting_order,
      SecureRandom.alphanumeric(4)
    ].join("#")
  end

  def score_for_sorting_order
    (999_999 - vote_count.to_i).to_s.rjust(6, "0")
  end

  def assign_tags
    self.tags = "#" if tags.blank?
  end
end

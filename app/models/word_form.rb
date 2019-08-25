# frozen_string_literal: true

class WordForm < ApplicationFormObject
  attribute :word_name, :string
  attribute :explanation, :string
  attribute :user_id, :string

  validates :word_name, presence: true, length: { maximum: 80 }
  validates :explanation, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
end

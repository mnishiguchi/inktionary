# frozen_string_literal: true

# Handles unliking a word.
class Word
  class RemoveVote < ApplicationCallable
    attr_reader :word_item, :user_id

    def initialize(word_item:, user_id:)
      @word_item = ensure_word_item(word_item)
      @user_id = ensure_user_id(user_id)
    end

    def call
      delete_vote
      sync_vote_count
    end

    private

    def vote_id
      ::Vote.where(user_id: user_id, word_id: word_item.item_id).items.first&.fetch("item_id")
    end

    def delete_vote
      return if vote_id.blank?

      ApplicationTable.find(item_id: vote_id).delete!
    end

    def sync_vote_count
      word_item.sync_vote_count
    end

    def ensure_word_item(value)
      if value.is_a?(Word)
        value
      elsif value =~ Word::WORD_ID_REGEX
        Word.from_hash(
          Word.find(item_id: value).items.first
        )
      else
        raise ArgumentError, "Word item is invalid: #{value}"
      end
    end

    def ensure_user_id(value)
      return value if value =~ URI::MailTo::EMAIL_REGEXP

      raise ArgumentError, "User id is invalid: #{value}"
    end
  end
end

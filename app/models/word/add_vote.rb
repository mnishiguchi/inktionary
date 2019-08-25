# frozen_string_literal: true

# Handles liking a word.
class Word
  class AddVote < ApplicationCallable
    attr_reader :word_item, :user_id

    def initialize(word_item:, user_id:)
      @word_item = ensure_word_item(word_item)
      @user_id = ensure_user_id(user_id)
    end

    def call
      if vote_record_already_exist?
        Word::RemoveVote.call(word_item: word_item, user_id: user_id)
      else
        create_vote
        sync_vote_count
      end
    end

    private

    def vote_record_already_exist?
      ::Vote.exist?(user_id: user_id, word_id: word_item.item_id)
    end

    def create_vote
      ::Vote.from_hash(word_id: word_item.item_id, user_id: user_id).save
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

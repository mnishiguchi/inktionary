# frozen_string_literal: true

# Handles liking a word.
class Word
  class Vote
    def self.call(*args, &block)
      new(*args, &block).call
    end

    attr_reader :word_item, :word_id, :user_id

    def initialize(word_item:, user_id:)
      @word_item = ensure_word_item(word_item)
      @word_id = @word_item.item_id
      @user_id = ensure_user_id(user_id)
    end

    def call
      return if vote_record_already_exist?

      create_vote
      update_vote_count
    end

    private

    def vote_record_already_exist?
      ::Vote.exist?(user_id: user_id, word_id: word_id)
    end

    def create_vote
      ::Vote.from_hash(word_id: word_id, user_id: user_id).save
    end

    def update_vote_count
      word_item.vote_count = Vote.count(word_id: word_id)
      word_item.validate!
      Word.update_vote_count(
        word_id:    word_item.item_id,
        vote_count: word_item.vote_count,
        dictionary: word_item.dictionary
      )
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

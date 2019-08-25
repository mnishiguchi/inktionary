# frozen_string_literal: true

# Handles removing a tag to a word.
class Word
  class RemoveTag < ApplicationCallable
    attr_reader :word_item, :word_id, :tag_name

    def initialize(word_item:, tag_name:)
      @word_item = ensure_word_item(word_item)
      @tag_name = ensure_tag_name(tag_name)
    end

    def call
      delete_tag
      sync_word_tags
    end

    private

    def tag_id
      ::Tag.where(tag_name: tag_name, word_id: word_item.item_id).items.first&.fetch("item_id")
    end

    def delete_tag
      return if tag_id.blank?

      ApplicationTable.find(item_id: tag_id).delete!
    end

    def sync_word_tags
      word_item.sync_tags
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

    def ensure_tag_name(value)
      value.presence || "#"
    end
  end
end

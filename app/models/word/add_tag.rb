# frozen_string_literal: true

# Handles adding a tag to a word.
class Word
  class AddTag
    def self.call(*args)
      new(*args).call
    end

    attr_reader :word_item, :word_id, :tag_name

    def initialize(word_item:, tag_name:)
      @word_item = ensure_word_item(word_item)
      @word_id = @word_item.item_id
      @tag_name = ensure_tag_name(tag_name)
    end

    def call
      return if tag_record_already_exist?

      create_tag
      update_word_tags
    end

    private

    def tag_record_already_exist?
      Tag.exist?(word_id: word_id, tag_name: tag_name)
    end

    def create_tag
      Tag.from_hash(word_id: word_id, word_name: tag_name).save
    end

    def update_word_tags
      word_item.tags = Tag.tag_list(word_id: word_id)
      word_item.validate!
      Word.update_tags(
        word_id: word_item.item_id,
        tags:    word_item.tags
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

    def ensure_tag_name(value)
      value.presence || "#"
    end
  end
end

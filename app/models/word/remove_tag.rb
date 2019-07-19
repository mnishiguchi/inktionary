# frozen_string_literal: true

class Word
  class RemoveTag
    def self.call(*args, &block)
      new(*args, &block).call
    end

    attr_reader :word_id, :tag_name

    def initialize(word_id:, tag_name:)
      @word_id = ensure_word_id(word_id)
      @tag_name = ensure_tag_name(tag_name)
    end

    def call
      raise NotImplementedError
    end
  end
end

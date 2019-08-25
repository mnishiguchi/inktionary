# frozen_string_literal: true

# Queries database and cache results.
class DictionarySearch
  class << self
    def by_term(query)
      return [] if query.blank?

      # TODO: cache
      Word.search(query).items.map { |item| Word.from_hash(item) }
    end

    def by_tag_name(tag_names)
      return [] if tag_names.blank?

      # TODO: cache
      Word.find_by_tag_name(tag_names).items.map { |item| Word.from_hash(item) }
    end

    def autocomplete(query)
      return [] if query.blank?

      # TODO: cache
      ApplicationTableItem.search(query).items.map { |item| item.fetch("word_name") }.uniq
    end

    def word_names
      # TODO: cache
      Word.pluck_word_names
    end

    def tag_names
      # TODO: cache
      Tag.pluck_word_names
    end
  end
end

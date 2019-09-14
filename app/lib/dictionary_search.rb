# frozen_string_literal: true

# Queries database and caches results.
class DictionarySearch
  class << self
    def by_term(query)
      return [] if query.blank?

      # TODO: cache
      Word.search(query).items
    end

    def by_tag_name(tag_names)
      return [] if tag_names.blank?

      # TODO: cache
      Word.find_by_tag_name(tag_names).items
    end

    def autocomplete(query)
      return Word.pluck_word_names if query.blank?

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

    def popular_words(limit = 10)
      # TODO: cache
      Word.pluck_popular_items.take(limit.to_i)
    end

    def top_contributors(limit = 10)
      # TODO: cache
      Word.pluck_authors.lazy
          .map { |item| item.fetch("user_id") }
          .each_with_object(Hash.new(0)) { |user_id, counts| counts[user_id] += 1 }
          .sort_by { |_user_id, count| count }.reverse
          .take(limit.to_i)
    end

    def word_tag_names(word_id)
      # TODO: cache
      word_item = Word.find(item_id: word_id).items.first
      return [] if word_item.nil?

      word_item.fetch("tags").split("#").reject(&:blank?)
    end
  end
end

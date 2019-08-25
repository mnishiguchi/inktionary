# frozen_string_literal: true

class User
  attr_reader :id

  def initialize(id:)
    @id = id
  end

  def upvoted_word_ids
    Vote.where(user_id: id).items.map { |item| item.fetch("word_id") }
  end

  def vote_ids
    Vote.where(user_id: id).items.map { |item| item.fetch("item_id") }
  end
end

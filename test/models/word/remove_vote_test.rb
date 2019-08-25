# frozen_string_literal: true

require "test_helper"

class Word::RemoveVoteTest < ActiveSupport::TestCase
  before do
    delete_items

    @word_item = build(:word)
    @word_item.save

    Word::AddVote.call(word_item: @word_item, user_id: "jimi@example.com")
  end

  it "deletes vote record" do
    assert_equal 1, ::Vote.where(word_id: @word_item.item_id).count
    Word::RemoveVote.call(word_item: @word_item, user_id: "jimi@example.com")
    assert_equal 0, ::Vote.where(word_id: @word_item.item_id).count
  end

  it "update vote count of word record" do
    assert_changes -> { ::Word.find(item_id: @word_item.item_id).items.first&.fetch("vote_count") } do
      Word::RemoveVote.call(word_item: @word_item, user_id: "jimi@example.com")
    end
  end
end

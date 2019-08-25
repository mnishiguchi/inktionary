# frozen_string_literal: true

require "test_helper"

class Word::AddVoteTest < ActiveSupport::TestCase
  before do
    delete_items

    @word_item = build(:word)
    @word_item.save
  end

  it "creates vote record" do
    assert_changes -> { ::Vote.where(word_id: @word_item.item_id) } do
      Word::AddVote.call(word_item: @word_item, user_id: "jimi@example.com")
    end
  end

  it "update vote count of word record" do
    assert_changes -> { ::Word.find(item_id: @word_item.item_id).items.first&.fetch("vote_count") } do
      Word::AddVote.call(word_item: @word_item, user_id: "jimi@example.com")
    end
  end
end

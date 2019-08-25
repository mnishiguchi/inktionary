# frozen_string_literal: true

require "test_helper"

class Word::RemoveTagTest < ActiveSupport::TestCase
  before do
    delete_items

    @word_item = build(:word)
    @word_item.save

    Word::AddTag.call(word_item: @word_item, tag_name: "AWS")
  end

  it "deletes tag record" do
    assert_equal 1, ::Tag.where(word_id: @word_item.item_id).count
    Word::RemoveTag.call(word_item: @word_item, tag_name: "AWS")
    assert_equal 0, ::Tag.where(word_id: @word_item.item_id).count
  end

  it "update tag count of word record" do
    assert_changes -> { ::Word.find(item_id: @word_item.item_id).items.first&.fetch("tags") } do
      Word::RemoveTag.call(word_item: @word_item, tag_name: "AWS")
    end
  end
end

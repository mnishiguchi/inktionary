# frozen_string_literal: true

require "test_helper"

class Word::AddTagTest < ActiveSupport::TestCase
  before do
    delete_items

    @word_item = build(:word)
    @word_item.save
  end

  it "creates tag record" do
    assert_changes -> { ::Tag.where(word_id: @word_item.item_id) } do
      Word::AddTag.call(word_item: @word_item, tag_name: "AWS")
    end
  end

  it "update tags of word record" do
    assert_changes -> { ::Word.find(item_id: @word_item.item_id).items.first&.fetch("tags") } do
      Word::AddTag.call(word_item: @word_item, tag_name: "AWS")
    end
  end
end

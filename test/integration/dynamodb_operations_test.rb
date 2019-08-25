# frozen_string_literal: true

require "test_helper"

class DynamodbOperationsTest < ActiveSupport::TestCase
  before do
    delete_items
  end

  describe "find" do
    it "returns correct result" do
      record = build(:word)
      record.save

      result = Word.find(item_id: record.item_id)

      assert_not_nil result.items
    end
  end

  describe "delete" do
    it "deletes an item" do
      record = build(:word, word_name: "api")
      record.save
      assert_equal 1, Word.find(item_id: record.item_id).count

      Word.delete(item_id: record.item_id)

      assert_equal 0, Word.find(item_id: record.item_id).count
    end
  end

  describe "find_by_user_id" do
    it "returns correct result" do
      record = build(:word, user_id: "jimi@example.com")
      record.save

      result = Word.find_by_user_id("jimi@example.com")

      assert_not_nil result.items
    end
  end

  describe "search" do
    it "returns correct result" do
      record = build(:word, word_name: "api")
      record.save

      result = Word.search("a")

      assert_not_nil result.items
    end
  end
end

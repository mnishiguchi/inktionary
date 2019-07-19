# frozen_string_literal: true

require "test_helper"

class WordTest < ActiveSupport::TestCase
  before do
    ApplicationTable.any_instance.stubs(:save).returns("stub")
  end

  it "has a valid factory" do
    record = build(:word)

    record.save

    assert record.valid?, record.errors.full_messages
  end

  describe "item_id" do
    it "has valid format" do
      record = build(:word)

      record.stubs(item_id: "random-item_id")
      assert_not record.valid?

      record.stubs(item_id: "Word#2019-07-23#1000")
      assert record.valid?, record.errors.full_messages
    end
  end

  describe "word_name" do
    it "has valid length" do
      record = build(:word)

      record.stubs(word_name: "")
      assert_not record.valid?

      record.stubs(word_name: "a" * 1001)
      assert_not record.valid?

      record.stubs(word_name: "API")
      assert record.valid?, record.errors.full_messages
    end
  end

  describe "dictionary" do
    it "has valid format" do
      record = build(:word)

      record.stubs(dictionary: "invalid dictionary")
      assert_not record.valid?

      record.stubs(dictionary: "api#999978#1234")
      assert record.valid?, record.errors.full_messages
    end
  end

  describe "explanation" do
    it "is present" do
      record = build(:word)

      record.stubs(explanation: nil)
      assert_not record.valid?
    end
  end

  describe "tags" do
    it "is present" do
      record = build(:word)

      record.stubs(tags: "")
      assert_not record.valid?
    end
  end

  describe "vote_count" do
    it "is numerical" do
      record = build(:word)

      record.stubs(vote_count: "string")
      assert_not record.valid?

      record.stubs(vote_count: nil)
      assert_not record.valid?
    end
  end

  describe "user_id" do
    it "has valid format" do
      record = build(:word)

      record.stubs(user_id: "random-user-id")
      assert_not record.valid?

      record.stubs(user_id: "masatoshi.nishiguchi@customink.com")
      assert record.valid?, record.errors.full_messages
    end
  end

  describe "abcd" do
    it "has valid format" do
      record = build(:word)

      record.stubs(abcd: "Invalid")
      assert_not record.valid?

      record.stubs(abcd: "A")
      assert_not record.valid?
    end
  end

  describe "updated_at" do
    it "is present" do
      record = build(:word)

      record.stubs(updated_at: nil)
      assert_not record.valid?
    end
  end
end

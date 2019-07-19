# frozen_string_literal: true

require "test_helper"

class TagTest < ActiveSupport::TestCase
  before do
    ApplicationTable.any_instance.stubs(:save).returns("stub")
  end

  it "has a valid factory" do
    record = build(:tag)

    record.save

    assert record.valid?, record.errors.full_messages
  end

  describe "item_id" do
    it "has valid format" do
      record = build(:tag)

      record.stubs(item_id: "random-item_id")
      assert_not record.valid?

      record.stubs(item_id: "Word#2019-07-23#1000")
      assert record.valid?, record.errors.full_messages
    end
  end

  describe "abcd" do
    it "has valid format" do
      record = build(:tag)

      record.stubs(abcd: "invalid abcd")
      assert_not record.valid?

      record.stubs(abcd: "a")
      assert record.valid?, record.errors.full_messages
    end
  end

  describe "word name" do
    it "has valid length" do
      record = build(:tag)

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
      record = build(:tag)

      record.stubs(dictionary: "Invalid")
      assert_not record.valid?

      record.stubs(dictionary: "invalid dictionary")
      assert_not record.valid?

      record.stubs(dictionary: "business")
      assert record.valid?, record.errors.full_messages
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class VoteTest < ActiveSupport::TestCase
  before do
    ApplicationTable.any_instance.stubs(:save).returns("stub")
  end

  it "has a valid factory" do
    record = build(:vote)

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

  describe "user_id" do
    it "has valid format" do
      record = build(:word)

      record.stubs(user_id: "random-user-id")
      assert_not record.valid?

      record.stubs(user_id: "masatoshi.nishiguchi@customink.com")
      assert record.valid?, record.errors.full_messages
    end
  end
end

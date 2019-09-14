# frozen_string_literal: true

require "test_helper"

class DictionarySearchTest < ActiveSupport::TestCase
  before do
    delete_items
  end

  describe "by_term" do
    it "returns a list of Word objects" do
      build(:word, word_name: "api").save

      result = DictionarySearch.by_term("a")

      assert_equal Array, result.class
      assert_equal Hash, result.first.class
    end
  end

  describe "autocomplete" do
    it "returns a list of words" do
      build(:word, word_name: "api").save

      result = DictionarySearch.autocomplete("a")

      assert_equal ["api"], result
    end
  end
end

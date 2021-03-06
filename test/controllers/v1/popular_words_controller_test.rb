# frozen_string_literal: true

require "test_helper"

class V1::PopularWordsControllerTest < ActionDispatch::IntegrationTest
  describe "index" do
    it "responds with correct json" do
      get v1_popular_words_url

      parsed_json = JSON.parse(response.body)

      assert_response :success
      assert_equal(true, parsed_json["result"].is_a?(Array))
    end
  end
end

# frozen_string_literal: true

require "test_helper"

class StandardizedJsonResponseTest < ActiveSupport::TestCase
  describe "Formatter.success" do
    it "formats json correctly" do
      assert_equal(
        { status: 200, json: { code: 200, result: { message: "OK" } } },
        StandardizedJsonResponse::Formatter.success(
          200
        )
      )
    end

    it "formats json correctly with custom message" do
      assert_equal(
        { status: 200, json: { code: 200, result: { message: "Woohoo!" } } },
        StandardizedJsonResponse::Formatter.success(
          200, message: "Woohoo!"
        )
      )
    end

    it "formats json correctly with custom content" do
      assert_equal(
        { status: 200, json: { code: 200, result: [:some, "data"] } },
        StandardizedJsonResponse::Formatter.success(
          200, content: [:some, "data"]
        )
      )
    end
  end

  describe "Formatter.failure" do
    it "formats success json correctly" do
      assert_equal(
        { status: 500, json: { error: { code: 500, message: "Internal Server Error" } } },
        StandardizedJsonResponse::Formatter.failure(
          500
        )
      )
    end

    it "formats json correctly with custom message" do
      assert_equal(
        { status: 500, json: { error: { code: 500, message: "Shit!" } } },
        StandardizedJsonResponse::Formatter.failure(
          500, message: "Shit!"
        )
      )
    end

    it "formats json correctly with custom content" do
      assert_equal(
        { status: 500, json: { error: [:some, "data"] } },
        StandardizedJsonResponse::Formatter.failure(
          500, content: [:some, "data"]
        )
      )
    end
  end

  describe "StatusCode" do
    it "parses symbol code correctly" do
      assert_equal(
        { "status" => 200, "message" => "OK" },
        StandardizedJsonResponse::StatusCode.new(:ok).as_json
      )

      assert_equal(
        { "status" => 304, "message" => "Not Modified" },
        StandardizedJsonResponse::StatusCode.new(:not_modified).as_json
      )

      assert_equal(
        { "status" => 500, "message" => "Internal Server Error" },
        StandardizedJsonResponse::StatusCode.new(:internal_server_error).as_json
      )
    end

    it "parses numeric code correctly" do
      assert_equal(
        { "status" => 200, "message" => "OK" },
        StandardizedJsonResponse::StatusCode.new(200).as_json
      )

      assert_equal(
        { "status" => 304, "message" => "Not Modified" },
        StandardizedJsonResponse::StatusCode.new(304).as_json
      )

      assert_equal(
        { "status" => 500, "message" => "Internal Server Error" },
        StandardizedJsonResponse::StatusCode.new(500).as_json
      )
    end
  end
end

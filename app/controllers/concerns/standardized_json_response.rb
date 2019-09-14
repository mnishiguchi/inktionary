# frozen_string_literal: true

# Custom render methods for rendering json in unified format.
module StandardizedJsonResponse
  def render_success_json(status_code = 200, message: nil, content: nil)
    render(
      Formatter.success(status_code, message: message, content: content)
    )
  end

  def render_failure_json(status_code = 500, message: nil, content: nil)
    render(
      Formatter.failure(status_code, message: message, content: content)
    )
  end

  # Prepares json data for API response. Optionally accepts custom message or content.
  class Formatter
    def self.success(status_code = 200, message: nil, content: nil)
      status_code = StatusCode.new(status_code, 500)
      default_content = { message: message || status_code.message }

      { status: status_code.status,
        json:   { code:   status_code.status,
                  result: content.nil? ? default_content : content } }
    end

    def self.failure(status_code = 500, message: nil, content: nil)
      status_code = StatusCode.new(status_code, 500)
      default_content = { code:    status_code.status,
                          message: message || status_code.message }

      { status: status_code.status,
        json:   { error: content.nil? ? default_content : content } }
    end
  end

  # Parses status code into integer code and corresponding message.
  class StatusCode
    attr_reader :status, :message

    def initialize(code, _default = 200)
      self.class.parse_status_code(code).tap do |parsed_status_code|
        @status = parsed_status_code
        @message = Rack::Utils::HTTP_STATUS_CODES[parsed_status_code]
      end
    end

    class << self
      def parse_status_code(code)
        if code.is_a?(Numeric) && (200..599).cover?(code)
          code.to_i
        else
          Rack::Utils::SYMBOL_TO_STATUS_CODE[code.to_sym]
        end
      end
    end
  end
end

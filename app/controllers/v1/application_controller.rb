# frozen_string_literal: true

module V1
  class ApplicationController < ActionController::Base
    include StandardizedJsonResponse

    protect_from_forgery with: :exception

    rescue_from StandardError do |exception|
      raise exception if Rails.env.delelopment?

      render_failure_json
    end
  end
end

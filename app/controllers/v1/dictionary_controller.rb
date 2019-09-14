# frozen_string_literal: true

module V1
  class DictionaryController < V1::ApplicationController
    # GET /v1/dictionary?q=a
    def index
      render_success_json(
        200, content: DictionarySearch.by_term(params[:q].to_s)
      )
    end
  end
end

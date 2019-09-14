# frozen_string_literal: true

module V1
  class PopularWordsController < V1::ApplicationController
    # GET /v1/popular_words?limit=6
    def index
      limit = params.fetch(:limit, 6).to_i
      render_success_json(
        200, content: DictionarySearch.popular_words(limit)
      )
    end
  end
end

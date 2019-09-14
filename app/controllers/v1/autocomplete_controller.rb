# frozen_string_literal: true

module V1
  class AutocompleteController < V1::ApplicationController
    # GET /v1/autocomplete?q=a
    def index
      render_success_json(
        200, content: DictionarySearch.autocomplete(params[:q].to_s)
      )
    end
  end
end

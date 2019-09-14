# frozen_string_literal: true

module V1
  class TagsController < V1::ApplicationController
    # GET /v1/tags
    def index
      render_success_json(
        200, content: DictionarySearch.tag_names
      )
    end
  end
end

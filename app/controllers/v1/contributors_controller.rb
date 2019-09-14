# frozen_string_literal: true

module V1
  class ContributorsController < V1::ApplicationController
    # GET /v1/contributors?limit=10
    # { code: 200, result: [["keira@example.org", 10]] }
    def index
      limit = params.fetch(:limit, 10)
      render_success_json(
        200, content: DictionarySearch.top_contributors(limit)
      )
    end
  end
end

# frozen_string_literal: true

# Current user's liking and unliking.
module V1
  class WordVotesController < V1::ApplicationController
    before_action :correct_user?

    # PUT /word_votes?word_id=123
    # Toggle liking of a word.
    def update
      @word_id = params.fetch(:word_id)
      @user_id = current_user&.id
      result = Word::AddVote.call(word_item: @word_id, user_id: @user_id)

      render_success_json(200, content: result)
    end

    private

    def current_user
      raise NotImplementedError
    end
  end
end

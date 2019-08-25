# frozen_string_literal: true

# Current user's liking and unliking.
module Words
  class VotesController < ApplicationController
    # PUT /words/:id/vote
    # Toggle liking of a word.
    def update
      @word_id = params.fetch(:word_id)
      @user_id = current_user&.id
      result = Word::AddVote.call(word_item: @word_id, user_id: @user_id)
      @word = Word.from_hash(result.attributes)

      flash[:notice] = "Your vote was successfully updated"

      respond_to do |format|
        format.js
      end
    end
  end
end

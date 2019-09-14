# frozen_string_literal: true

# Handles tags that are attached to a word.
module Words
  class TagsController < ApplicationController
    # POST /words/:word_id/tags
    def create
      @word_id = params.fetch(:word_id)
      @tag_name = params.fetch(:tag_name)
      Word::AddTag.call(word_item: @word_id, tag_name: @tag_name)
      @tag_names = DictionarySearch.word_tag_names(@word_id)

      respond_to do |format|
        format.js
      end
    end

    # DELETE /words/:word_id/tag/:id
    def destroy
      @word_id = params.fetch(:word_id)
      @tag_name = params.fetch(:id)
      Word::RemoveTag.call(word_item: @word_id, tag_name: @tag_name)
      @tag_names = DictionarySearch.word_tag_names(@word_id)

      respond_to do |format|
        format.js
      end
    end
  end
end

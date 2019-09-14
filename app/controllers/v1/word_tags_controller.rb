# frozen_string_literal: true

# Handles tags that are attached to a word.
module V1
  class WordTagsController < V1::ApplicationController
    before_action :authorize_author, only: %i[create delete]

    # GET /word_tags?word_id=123
    def index
      word_id = params.fetch(:word_id)
      tag_names = DictionarySearch.word_tag_names(word_id)

      render_success_json(
        200, content: tag_names
      )
    end

    # POST /word_tags?word_id=123&tag_name=tech
    def create
      word_id = params.fetch(:word_id)
      tag_name = params.fetch(:tag_name)
      Word::AddTag.call(word_item: word_id, tag_name: tag_name)
      tag_names = DictionarySearch.word_tag_names(word_id)

      render_success_json(
        200, content: tag_names
      )
    end

    # DELETE /word_tag?word_id=123&tag_name=tech
    def destroy
      word_id = params.fetch(:word_id)
      tag_name = params.fetch(:id)
      Word::RemoveTag.call(word_item: word_id, tag_name: tag_name)
      tag_names = DictionarySearch.word_tag_names(word_id)

      render_success_json(
        200, content: tag_names
      )
    end

    private

    def authorize_author
      raise NotImplementedError
    end
  end
end

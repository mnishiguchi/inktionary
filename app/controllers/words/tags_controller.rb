# frozen_string_literal: true

# Handles tags that are attached to a word.
module Words
  class TagsController < ApplicationController
    # POST /words/:word_id/tags
    def create
      @word_id = params.fetch(:word_id)
      @tag_name = params.fetch(:tag_name)
      Word::AddTag.call(word_item: @word_id, tag_name: @tag_name)
      @tag_names = find_tag_names

      respond_to do |format|
        format.js
      end
    end

    # DELETE /words/:word_id/tag/:id
    def destroy
      @word_id = params.fetch(:word_id)
      @tag_name = params.fetch(:id)
      Word::RemoveTag.call(word_item: @word_id, tag_name: @tag_name)
      @tag_names = find_tag_names

      respond_to do |format|
        format.js
      end
    end

    private

    def find_tag_names
      word_item = Word.find(item_id: @word_id).items.first
      word_item.fetch("tags").split("#").reject(&:blank?)
    end
  end
end

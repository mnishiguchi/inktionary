# frozen_string_literal: true

module V1
  class WordsController < V1::ApplicationController
    before_action :authorize_author
    before_action :validate_word_form, only: %i[create update]

    # POST /v1/words
    def create
      word = Word.new
      word.assign_attributes(@word_form.attributes)
      word.save

      render_success_json(200)
    end

    # PATCH  /v1/words/:id
    def update
      word = Word.new
      word.assign_attributes(@word_form.attributes.merge(item_id: params[:id]))
      word.update

      render_success_json(200)
    end

    # TODO: Authorization: only author can delete.
    # DELETE /v1/words/:id
    def destroy
      ApplicationTableItem.delete(item_id: params[:id])

      render_success_json(200)
    end

    private

    def authorize_author
      raise NotImplementedError
    end

    def validate_word_form
      @word_form = WordForm.new
      @word_form.assign_attributes(word_form_params)
      @word_form.validate!
    end

    def word_form_params
      params.require(:word_form).permit(
        :word_name,
        :explanation,
        :user_id
      )
    end
  end
end

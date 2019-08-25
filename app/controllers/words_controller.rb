# frozen_string_literal: true

class WordsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  before_action :validate_word_form, only: %i[create update]

  PER_PAGE = 10

  # GET /words?q=WIP&tag=tech
  def index
    @q = params[:q]
    @words = ::DictionarySearch.by_term(@q).yield_self do |w|
      Kaminari.paginate_array(w).page(params[:page]).per(PER_PAGE)
    end
    @autocomplete = ::DictionarySearch.word_names
  end

  # GET /words/new
  def new
    @word_form = WordForm.new
  end

  # POST /words
  def create
    word = Word.new
    word.assign_attributes(@word_form.attributes)
    word.save
    flash[:notice] = "Word was created"
    redirect_to words_path(q: word.word_name)
  rescue ActiveModel::ValidationError => _e
    render :new
  end

  # GET /words/:id
  def show
    @word_id = params[:id]
    word_item = Word.find(item_id: @word_id).items.first
    word_form_attributes = word_item.slice("word_name", "explanation")
    @word_form = WordForm.new
    @word_form.assign_attributes(word_form_attributes)
    @tag_names = word_item.fetch("tags").split("#").reject(&:blank?)
    @autocomplete = DictionarySearch.tag_names
  end

  # PATCH  /words/:id
  def update
    word = Word.new
    word.assign_attributes(@word_form.attributes.merge(item_id: params[:id]))
    word.update
    flash[:notice] = "Word was updated"
    redirect_to words_path(q: word.word_name)
  rescue ActiveModel::ValidationError => _e
    render :show
  end

  # TODO: Authorization: only author can delete.
  # DELETE /words/:id
  def destroy
    ApplicationTableItem.delete(item_id: params[:id])
    flash[:notice] = "Word was deleted"
    redirect_to redirection_url
  end

  private

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

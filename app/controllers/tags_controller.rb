# frozen_string_literal: true

# All tags
class TagsController < ApplicationController
  PER_PAGE = WordsController::PER_PAGE

  # GET /tags
  def index
    @tag_names = DictionarySearch.tag_names
  end

  # GET /tags/:id
  def show
    @tag_name = params.fetch(:id)
    @words = ::DictionarySearch.by_tag_name(@tag_name).map { |item| Word.from_hash(item) }.yield_self do |w|
      Kaminari.paginate_array(w).page(params[:page]).per(PER_PAGE)
    end
  end
end

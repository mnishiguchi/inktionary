# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :authenticate_user!
  before_action :upvoted_word_ids
  before_action :popular_words
  before_action :top_contributors
  before_action :store_location

  protected

  def authenticate_user!
    return if user_logged_in?

    flash[:info] = "Please log in"
    redirect_to redirection_url
  end

  def upvoted_word_ids
    @upvoted_word_ids ||= current_user&.upvoted_word_ids
  end

  def popular_words
    @popular_words ||= Word.popular(6)
  end

  def top_contributors
    @top_contributors ||= Word.top_contributors(10)
  end
end

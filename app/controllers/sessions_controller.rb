# frozen_string_literal: true

# TODO: Use AWS Cognito Google login in production.
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    log_in User.new(id: "jimi@example.com")
    flash[:notice] = "Welcome to this site"
    redirect_to redirection_url
  end

  def destroy
    if user_logged_in?
      log_out
      flash[:notice] = "See you later"
    end
    redirect_to redirection_url
  end
end

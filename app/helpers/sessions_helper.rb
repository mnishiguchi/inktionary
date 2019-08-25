# frozen_string_literal: true

module SessionsHelper
  SESSION_KEY_USER_ID = :user_id

  def log_in(user)
    session[SESSION_KEY_USER_ID] = user.id
    @current_user = user
  end

  def current_user
    return if session[SESSION_KEY_USER_ID].nil?

    @current_user ||= User.new(id: session[SESSION_KEY_USER_ID])
  end

  def user_logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(SESSION_KEY_USER_ID)
    @current_user = nil
  end

  # Stored location or to the default
  def redirection_url(default: root_url)
    (session[:forwarding_url] || default).tap { session.delete(:forwarding_url) }
  end

  # Stores the URL that a user wants to access.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end

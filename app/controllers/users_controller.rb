# frozen_string_literal: true

# User dashboard
class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /user
  def show; end
end

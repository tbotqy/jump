# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users/:id
  def show
    user = User.find(params[:id])

    if user != current_user
      raise Errors::BadRequest, "Given id is not authenticated user's."
    end

    render json: user
  end
end

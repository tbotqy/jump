# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /users
  def index
    render json: User.new_arrivals!.map(&:as_index_json)
  end

  # GET /users/:screen_name
  def show
    user = User.find_latest_by_screen_name!(params[:screen_name])
    render json: user
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i|show|

  # GET /users/me
  def me
    render json: current_user
  end

  # GET /users/:screen_name
  def show
    user = User.find_latest_by_screen_name!(params[:screen_name])
    render json: user
  end

  # DELETE /users/:id
  def destroy
    user = User.find(params[:id])
    authorize_operation_for!(user)

    DestroyUserJob.perform_later(user_id: params[:id])
    sign_out user

    head :accepted
  end
end

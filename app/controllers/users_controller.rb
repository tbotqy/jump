# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users/:id
  def show
    user = User.find(params[:id])
    authorize_operation_for!(user)

    render json: user
  end

  # DELETE /users/:id
  def destroy
    user = User.find(params[:id])
    authorize_operation_for!(user)

    DestroyUserJob.perform_later(user_id: params[:id])
    head :accepted
  end
end

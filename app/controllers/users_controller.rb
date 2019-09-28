# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users/me
  def me
    render json: current_user
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

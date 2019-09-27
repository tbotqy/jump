# frozen_string_literal: true

module Users
  class FolloweesController < ApplicationController
    before_action :authenticate_user!

    # POST /users/:id/followees
    def create
      user = User.find(params[:user_id])
      authorize_operation_for!(user)
      RenewUserFolloweesService.call!(user_id: params[:user_id])
      render json: { total_followees_count: user.followees.count }
    end
  end
end

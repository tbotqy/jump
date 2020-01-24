# frozen_string_literal: true

module Me
  class FolloweesController < ApplicationController
    before_action :authenticate_user!

    # POST /me/followees
    def create
      RenewUserFolloweesService.call!(user_id: current_user.id)
      render json: { total_followees_count: current_user.followees.count }
    end
  end
end

# frozen_string_literal: true

module Users
  class FolloweeStatusesController < ApplicationController
    before_action :authenticate_user!

    def index
      user = User.find(params[:user_id])
      authorize_operation_for!(user)
      statuses = CollectFolloweeStatusesService.call!(params_to_collect_by)
      render json: statuses
    end

    private
      def params_to_collect_by
        params.permit(:user_id, :year, :month, :day, :page).to_h.symbolize_keys
      end
  end
end

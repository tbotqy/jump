# frozen_string_literal: true

module Users
  class StatusesController < ApplicationController
    def index
      user = User.find(params[:user_id])

      check_ownership_of!(user) if user.protected_flag?

      statuses = CollectUserStatusesService.call!(**params_to_collect_by)
      render json: statuses
    end

    private
      def params_to_collect_by
        params.permit(:user_id, :year, :month, :day, :page).to_h.symbolize_keys
      end
  end
end

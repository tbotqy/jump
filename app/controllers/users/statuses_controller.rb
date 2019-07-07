# frozen_string_literal: true

module Users
  class StatusesController < ApplicationController
    before_action :authenticate_user!

    def index
      user = User.find(params[:user_id])
      authorize_operation_for!(user)
      statuses = CollectUserStatusesService.call!(params_to_collect_by)
      render json: statuses
    end

    # PUT /users/:id/statuses
    def update
      user = User.find(params[:user_id])
      authorize_operation_for!(user)
      ImportTweetsJob.perform_later(user_id: params[:user_id])
      head :accepted
    end

    private
      def params_to_collect_by
        params.permit(:user_id, :year, :month, :day, :page).to_h.symbolize_keys
      end
  end
end

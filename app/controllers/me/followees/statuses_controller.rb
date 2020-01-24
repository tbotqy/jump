# frozen_string_literal: true

module Me
  module Followees
    class StatusesController < ApplicationController
      before_action :authenticate_user!

      def index
        statuses = CollectFolloweeStatusesService.call!(**params_to_collect_by, user_id: current_user.id)
        render json: statuses
      end

      private
        def params_to_collect_by
          params.permit(:year, :month, :day, :page).to_h.symbolize_keys
        end
    end
  end
end

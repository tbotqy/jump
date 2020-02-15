# frozen_string_literal: true

module Me
  class StatusesController < ApplicationController
    before_action :authenticate_user!

    def index
      user_id = current_user.id
      statuses = CollectUserStatusesService.call!(**params_to_collect_by, user_id: user_id)
      render json: statuses
    end

    def create
      if current_user.tweet_import_progress.blank?
        MakeInitialTweetImportJob.perform_later(user_id: current_user.id)
      end
      head :accepted
    end

    # PUT /me/statuses
    def update
      if current_user.tweet_import_lock.blank?
        MakeAdditionalTweetImportJob.perform_later(user_id: current_user.id)
      end
      head :accepted
    end

    private
      def params_to_collect_by
        params.permit(:year, :month, :day, :page).to_h.symbolize_keys
      end
  end
end

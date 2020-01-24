# frozen_string_literal: true

module Me
  class StatusesController < ApplicationController
    before_action :authenticate_user!

    def index
      user_id  = current_user.id
      statuses = CollectUserStatusesService.call!(**params_to_collect_by, user_id: user_id)
      render json: statuses
    end

    def create
      if current_user.tweet_import_progress.present?
        head :too_many_requests
      else
        MakeInitialTweetImportJob.perform_later(user_id: current_user.id)
        head :accepted
      end
    end

    # PUT /me/statuses
    def update
      if current_user.tweet_import_lock.present?
        head :too_many_requests
      else
        MakeAdditionalTweetImportJob.perform_later(user_id: current_user.id)
        head :accepted
      end
    end

    private
      def params_to_collect_by
        params.permit(:year, :month, :day, :page).to_h.symbolize_keys
      end
  end
end

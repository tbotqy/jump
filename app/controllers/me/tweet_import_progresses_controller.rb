# frozen_string_literal: true

module Me
  class TweetImportProgressesController < ApplicationController
    before_action :authenticate_user!

    # GET /me/tweet_import_progress
    def show
      progress = TweetImportProgress.find_by!(user: current_user)
      render json: progress
    end
  end
end

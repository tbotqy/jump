# frozen_string_literal: true

module Users
  class TweetImportProgressesController < ApplicationController
    before_action :authenticate_user!

    # GET /users/:user_id/tweet_import_progress
    def show
      user = User.find(params[:user_id])
      authorize_operation_for!(user)
      progress = TweetImportProgress.find_by!(user: user)

      render json: progress
    end
  end
end

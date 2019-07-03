# frozen_string_literal: true

module Users
  class ImportProgressesController < ApplicationController
    before_action :authenticate_user!

    # GET /users/:user_id/import_progress
    def show
      user = User.find(params[:user_id])
      authorize_operation_for!(user)
      latest_progress = user.tweet_import_job_progresses.last!

      render json: latest_progress
    end
  end
end

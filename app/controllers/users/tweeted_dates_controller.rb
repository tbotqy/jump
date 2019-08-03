# frozen_string_literal: true

module Users
  class TweetedDatesController < ApplicationController
    before_action :authenticate_user!

    def index
      user = User.find(params[:user_id])
      authorize_operation_for!(user)

      tweeted_dates = StatusesDecorator.new(user.statuses).tweeted_dates
      raise Errors::NotFound if tweeted_dates.blank?

      render json: tweeted_dates
    end
  end
end

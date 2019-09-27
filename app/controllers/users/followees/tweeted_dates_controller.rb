# frozen_string_literal: true

module Users
  module Followees
    class TweetedDatesController < ApplicationController
      before_action :authenticate_user!

      def index
        user = User.find(params[:user_id])
        authorize_operation_for!(user)

        followee_statuses = Status.joins(:user).merge(User.where(twitter_id: user.followees.pluck(:twitter_id)))
        raise Errors::NotFound if followee_statuses.blank?

        tweeted_dates = StatusesDecorator.new(followee_statuses).tweeted_dates
        render json: tweeted_dates
      end
    end
  end
end

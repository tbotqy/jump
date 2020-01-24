# frozen_string_literal: true

module Me
  module Followees
    class TweetedDatesController < ApplicationController
      before_action :authenticate_user!

      def index
        followee_statuses = Status.joins(:user).merge(User.where(twitter_id: current_user.followees.pluck(:twitter_id)))
        raise Errors::NotFound if followee_statuses.blank?

        tweeted_dates = StatusesDecorator.new(followee_statuses).tweeted_dates
        render json: tweeted_dates
      end
    end
  end
end

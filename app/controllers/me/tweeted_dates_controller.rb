# frozen_string_literal: true

module Me
  class TweetedDatesController < ApplicationController
    before_action :authenticate_user!

    def index
      tweeted_dates = StatusesDecorator.new(current_user.statuses).tweeted_dates
      raise Errors::NotFound if tweeted_dates.blank?
      render json: tweeted_dates
    end
  end
end

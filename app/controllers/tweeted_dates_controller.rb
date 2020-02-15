# frozen_string_literal: true

class TweetedDatesController < ApplicationController
  def index
    tweeted_dates = StatusesDecorator.new(Status.not_protected).tweeted_dates
    render json: tweeted_dates
  end
end

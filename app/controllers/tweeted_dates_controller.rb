# frozen_string_literal: true

class TweetedDatesController < ApplicationController
  def index
    tweeted_dates = StatusesDecorator.new(Status.not_private).tweeted_dates
    raise Errors::NotFound if tweeted_dates.blank?
    render json: tweeted_dates
  end
end

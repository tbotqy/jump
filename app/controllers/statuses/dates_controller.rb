# frozen_string_literal: true

module Statuses
  class DatesController < ApplicationController
    def index
      tweeted_dates = StatusesDecorator.new(Status.not_private).tweeted_dates
      raise Errors::NotFound if tweeted_dates.blank?

      render json: tweeted_dates
    end
  end
end

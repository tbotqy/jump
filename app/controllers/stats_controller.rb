# frozen_string_literal: true

class StatsController < ApplicationController
  def show
    status_count = StatusCount.current_count
    user_count   = User.count
    render json: {
      status_count: status_count.to_s(:delimited),
      user_count:   user_count.to_s(:delimited)
    }
  end
end

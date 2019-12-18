# frozen_string_literal: true

class StatsController < ApplicationController
  def show
    status_count = StatusCount.current_count
    user_count   = User.count
    render json: {
      statusCount: status_count.to_s(:delimited),
      userCount:   user_count.to_s(:delimited)
    }
  end
end

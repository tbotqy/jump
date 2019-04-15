# frozen_string_literal: true

class PagesController < ApplicationController
  def service_top
    @total_user_num   = User.active.count
    @total_status_num = ActiveStatusCount.current_count
  end

  def for_users
  end
end

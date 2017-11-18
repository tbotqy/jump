class PagesController < ApplicationController

  def service_top
    @total_user_num   = User.active.count
    @total_status_num = DataSummary.active_status_count
  end

  def for_users
  end

  def browsers
  end

  def sorry
  end
end

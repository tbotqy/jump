# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter :check_login, :except => ["index"]

  def index
    # check if user is logged in
    if @logged_in
      redirect_to :action => "home_timeline"
    else
      @show_footer = true
      @total_status_num = Status.get_total_status_num
    end
  end
  
  def sent_tweets
    # shows the tweets tweeted by logged-in user
    @title = "あなたのツイート"

    # check if date is specified
    specified_date = params[:date]
    
    @statuses = nil
    fetch_num = 10
    initial_fetch_num = fetch_num + 1
    # plus 1 to check if 'read more' should be shown in the view
    if specified_date
      # fetch 10(+1) statuses in specified date
      @statuses = Status.get_status_with_date(@@current_user,specified_date,initial_fetch_num)
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.get_latest_status(@@current_user.id,initial_fetch_num)
    end
    
    if !@statuses
      @show_footer = true
    else
      if @statuses.size == initial_fetch_num
        @has_next = true
        @statuses.pop
      else
        @has_next = false
      end
    end
  end
end

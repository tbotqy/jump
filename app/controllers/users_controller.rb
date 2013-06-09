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
    specified_date = params[:date].presense
    
    statsues = nil
    if specified_date
      # fetch 10 statuses in specified date
      statuses = Status.get_status_with_date(@@current_user,specified_date,10)
    else
      # just fetch 10 latest statuses
      statuses = Status.get_latest_status(@@current_user.id,10)
    end
  end
end

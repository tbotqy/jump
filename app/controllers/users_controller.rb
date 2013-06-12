# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter :check_login, :except => ["index","public_timeline"]
  
  def index
    # check if user is logged in
    if logged_in?
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
      @statuses = Status.get_status_between(specified_date,initial_fetch_num).owned_by_current_user(@@user_id)
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.get_latest_status(initial_fetch_num).owned_by_current_user(@@user_id)
    end
    
    if @statuses.present?
      if @statuses.size == initial_fetch_num
        @has_next = true
        @statuses.pop
      else
        @has_next = false
      end
      # get the oldest tweet's posted timestamp
      @oldest_timestamp = @statuses.last.twitter_created_at
    else
      @show_footer = true
      @oldest_timestamp = false
    end
  end

  def home_timeline
    # shows the home timeline 
    @title = "ホームタイムライン"

    # check if user has any friend
    unless User.find(@@user_id).has_friend?
      @error_type = "no_friend_list" || "no_registored_frind"
      return
    end
    
    # check if date is specified
    specified_date = params[:date]
    
    @statuses = nil
    fetch_num = 10
    initial_fetch_num = fetch_num + 1
    # plus 1 to check if 'read more' should be shown in the view
    if specified_date
      # fetch 10(+1) statuses in specified date
      @statuses = Status.get_status_between(specified_date,initial_fetch_num).owned_by_friend_of(@@user_id)
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.get_latest_status(initial_fetch_num).owned_by_friend_of(@@user_id)
    end
    
    if @statuses.present?
      if @statuses.size == initial_fetch_num
        @has_next = true
        @statuses.pop
      else
        @has_next = false
      end
      # get the oldest tweet's posted timestamp
      @oldest_timestamp = @statuses.last.twitter_created_at
    else
      @show_footer = true
      @oldest_timestamp = false
    end
  end

  def public_timeline
    # shows the public timeline 
    @title = "パブリックタイムライン"

    # check if date is specified
    specified_date = params[:date]
    
    @statuses = nil
    fetch_num = 10
    initial_fetch_num = fetch_num + 1
    # plus 1 to check if 'read more' should be shown in the view
    if specified_date
      # fetch 10(+1) statuses in specified date
      @statuses = Status.get_status_between(specified_date,initial_fetch_num).owned_by_active_user
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.get_latest_status(initial_fetch_num).owned_by_active_user
    end
    
    if @statuses.present?
      if @statuses.size == initial_fetch_num
        @has_next = true
        @statuses.pop
      else
        @has_next = false
      end
      # get the oldest tweet's posted timestamp
      @oldest_timestamp = @statuses.last.twitter_created_at
    else
      @show_footer = true
      @oldest_timestamp = false
    end
  end
  
end

# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter :check_login, :except => ["index","for_users","browsers","public_timeline"]
  before_filter :check_tweet_import, :except => ["index","for_users","browsers","public_timeline"]
  
  def index
    # check if user is logged in
    if logged_in?
      redirect_to :action => "sent_tweets"
    else
      @title = "あの日のつぶやきへジャンプ"
      @show_header = false
      @show_to_page_top = false
      @show_footer = true
      @show_scrollbar = true
      @total_user_num = User.get_active_user_count
      @total_status_num = Status.get_active_status_count
    end
  end
  
  def for_users
    @title = "timedline.me - ご利用に際して"
    @show_header = false
    @show_to_page_top = false
  end
  
  def browsers
    @title = "対応ブラウザについて"
    @show_footer = true
  end
  
  def sent_tweets

    # shows the tweets tweeted by logged-in user
    @title = "あなたのツイート"
    @show_scrollbar = true
    @has_next = false
    # check if date is specified
    specified_date = params[:date]
    
    @statuses = nil
    fetch_num = 10
    # plus 1 to check if 'read more' should be shown in the view
    if specified_date
      # fetch 10(+1) statuses in specified date
      @statuses = Status.showable.use_index(:idx_p_d_u_tca_sisr).get_status_in_date(specified_date,fetch_num).owned_by_current_user(@@user_id)
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.showable.use_index(:idx_p_d_u_sisr).get_latest_status(fetch_num).owned_by_current_user(@@user_id)
    end
    
    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str
      
      # check if there is more status to show
      older_status = Status.showable.use_index(:idx_p_d_u_sisr).get_older_status_by_tweet_id( @oldest_tweet_id,1 ).owned_by_current_user(@@user_id)
      # use size to prevent un-indexed query
      @has_next = older_status.length > 0 
    else
      @show_footer = true
      @oldest_tweet_id = false
    end
  end

  def home_timeline
    # shows the home timeline 
    @title = "ホームタイムライン"
    @show_scrollbar = true
    @has_next = false
    # check if user has any friend
    unless User.find(@@user_id).has_friend?
      @error_type = "no_friend_list"
      return
    end
    
    # check if date is specified
    specified_date = params[:date]
    
    @statuses = nil
    fetch_num = 10
    # plus 1 to check if 'read more' should be shown in the view
    if specified_date
      # fetch 10(+1) statuses in specified date
      @statuses = Status.showable.use_index(:idx_p_d_u_tca_sisr).get_status_in_date(specified_date,fetch_num).owned_by_friend_of(@@user_id)
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.showable.use_index(:idx_p_d_u_sisr).get_latest_status(fetch_num).owned_by_friend_of(@@user_id)
    end
    
    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str
      
      # check if there is more status to show
      older_status = Status.showable.use_index(:idx_p_d_u_sisr).get_older_status_by_tweet_id( @oldest_tweet_id,1 ).owned_by_friend_of(@@user_id)
      @has_next = older_status.length > 0
    else
      @show_footer = true
      @oldest_tweet_id = false
    end
  end

  def public_timeline
    # shows the public timeline 
    @title = "パブリックタイムライン"
    @show_scrollbar = true
    @has_next = false
    # check if date is specified
    specified_date = params[:date]
    
    @statuses = nil
    fetch_num = 10
    # plus 1 to check if 'read more' should be shown in the view
    if specified_date
      # fetch 10(+1) statuses in specified date
      @statuses = Status.showable.use_index(:idx_p_d_tca_sisr).get_status_in_date(specified_date,fetch_num)
    else
      # just fetch 10(+1) latest statuses
      @statuses = Status.showable.use_index(:idx_p_d_sisr).get_latest_status(fetch_num)
    end
    
    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str
      
      # check if there is more status to show
     older_status = Status.showable.use_index(:idx_p_d_sisr).get_older_status_by_tweet_id( @statuses.last.status_id_str,1 )
      @has_next = older_status.length > 0;
    else
      @show_footer = true
      @oldest_tweet_id = false
    end
  end

  def setting
    @title = "データ管理"
    @count_statuses = @@current_user.statuses.count
    @count_friends = @@current_user.friends.count
    @status_updated_at = Time.zone.at(@@current_user.statuses_updated_at).strftime('%F %T')
    @friend_updated_at = Time.zone.at(@@current_user.friends_updated_at).strftime('%F %T')
    @profile_updated_at = Time.zone.at(@@current_user.updated_at).strftime('%F %T')
    @show_scrollbar = true
    @show_footer = true
  end

  def delete_account
  end
  
end

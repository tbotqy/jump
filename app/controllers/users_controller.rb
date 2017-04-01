# -*- coding: utf-8 -*-
class UsersController < ApplicationController

  before_filter :check_login, :except => ["index","for_users","browsers","public_timeline"]
  before_filter :check_tweet_import, :except => ["index","for_users","browsers","public_timeline"]

  def index
    return redirect_to(action: :sent_tweets) if logged_in?

    @show_header = false
    @show_to_page_top = false
    @show_footer = true
    @show_scrollbar = true
    @total_user_num = User.active.count
    @total_status_num = Stat.active_status_count
  end

  def for_users
    @title = "ご利用に際して"
    @show_header = false
    @show_to_page_top = false
  end

  def browsers
    @title = "対応ブラウザについて"
    @show_footer = true
  end

  def sent_tweets

    # shows the tweets tweeted by logged-in user

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @@current_user

    @title = "#{@timeline_owner.name}(@#{@timeline_owner.screen_name}) さんのツイート"
    @show_scrollbar = true
    @has_next = false
    # check if date is specified
    specified_date = params[:date]

    if specified_date
      @title = convert_hyphen_in_date_to_japanese(specified_date) + "の" + " "+@title
    end

    @statuses = nil
    fetch_num = 10

    if specified_date
      # fetch statuses in specified date
      @statuses = Status.showable.get_status_in_date(specified_date,fetch_num).owned_by_current_user(@@user_id)
    else
      # just fetch latest statuses
      @statuses = Status.showable.get_latest_status(fetch_num).owned_by_current_user(@@user_id)
    end

    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str

      # check if read-more button should be shown
      older_status = Status.showable.get_older_status_by_tweet_id( @oldest_tweet_id,1 ).owned_by_current_user(@@user_id)
      @has_next = older_status.length > 0
    else
      @oldest_tweet_id = false
    end

  end

  def home_timeline
    # shows the home timeline

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @@current_user

    @title = "#{@timeline_owner.name}(@#{@timeline_owner.screen_name}) さんのホームタイムライン"
    @show_scrollbar = true
    @has_next = false
     # check if date is specified
    specified_date = params[:date]

    if specified_date
      @title = convert_hyphen_in_date_to_japanese(specified_date) + "の" + " "+@title
    end

    @statuses = nil
    fetch_num = 10

    if specified_date
      # fetch statuses in specified date
      @statuses = Status.showable.get_status_in_date(specified_date,fetch_num).owned_by_friend_of(@@user_id)
    else
      # just fetch latest statuses
      @statuses = Status.showable.force_index(:idx_u_tcar_sisr_on_statuses).get_latest_status(fetch_num).owned_by_friend_of(@@user_id)
    end

    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str

      # check if read-more button should be shown
      older_status = Status.showable.force_index(:idx_u_on_statuses).owned_by_friend_of(@@user_id).get_older_status_by_tweet_id( @oldest_tweet_id,1 )
      @has_next = older_status.length > 0
    else
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

    if specified_date
      @title = convert_hyphen_in_date_to_japanese(specified_date) + "の" + @title
    end

    @statuses = nil
    fetch_num = 10

    if specified_date
      # fetch statuses in specified date
      @statuses = Status.showable.get_status_in_date(specified_date,fetch_num)
    else
      # just latest statuses
      @statuses = Status.showable.get_latest_status(fetch_num)
    end

    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str

      # check if read-more button should be shown
      older_status = Status.showable.get_older_status_by_tweet_id( @statuses.last.status_id_str,1 )
      @has_next = older_status.length > 0;
    else
      @oldest_tweet_id = false
    end
  end

  def setting
    @title = "データ管理"
    @count_statuses = @@current_user.statuses.count
    @count_friends = @@current_user.friends.count
    @status_updated_at = Time.zone.at(@@current_user.statuses_updated_at).strftime('%F %T')

    @friend_updated_at = @@current_user.friends_updated_at
    if @friend_updated_at == 0
      @friend_updated_at = "---"
    else
      @friend_updated_at = Time.zone.at(@friend_updated_at).strftime('%F %T')
    end
    @profile_updated_at = Time.zone.at(@@current_user.updated_at).strftime('%F %T')
    @show_scrollbar = true
    @show_footer = true
  end

  def delete_account
  end

end

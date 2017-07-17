# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :check_login,        only: %w|sent_tweets home_timeline setting delete_account|
  before_filter :check_tweet_import, only: %w|sent_tweets home_timeline setting delete_account|

  def index
    return redirect_to(action: :sent_tweets) if logged_in?

    @total_user_num   = User.active.count
    @total_status_num = DataSummary.active_status_count
  end

  def sent_tweets

    # shows the tweets tweeted by logged-in user

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @current_user

    @title = "#{@timeline_owner.name}(@#{@timeline_owner.screen_name}) さんのツイート"
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
      @statuses = Status.showable.get_status_in_date(specified_date,fetch_num).owned_by_current_user(@current_user.id)
    else
      # just fetch latest statuses
      @statuses = Status.showable.get_latest_status(fetch_num).owned_by_current_user(@current_user.id)
    end

    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str

      # check if read-more button should be shown
      older_status = Status.showable.get_older_status_by_tweet_id( @oldest_tweet_id,1 ).owned_by_current_user(@current_user.id)
      @has_next = older_status.length > 0
    else
      @oldest_tweet_id = false
    end

  end

  def home_timeline
    # shows the home timeline

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @current_user

    @title = "#{@timeline_owner.name}(@#{@timeline_owner.screen_name}) さんのホームタイムライン"
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
      @statuses = Status.showable.get_status_in_date(specified_date,fetch_num).owned_by_friend_of(@current_user.id)
    else
      # just fetch latest statuses
      @statuses = Status.showable.force_index(:idx_u_tcar_sisr_on_statuses).get_latest_status(fetch_num).owned_by_friend_of(@current_user.id)
    end

    if @statuses.present?
      # get the oldest tweet's status_id_str
      @oldest_tweet_id = @statuses.last.status_id_str

      # check if read-more button should be shown
      older_status = Status.showable.force_index(:idx_u_on_statuses).owned_by_friend_of(@current_user.id).get_older_status_by_tweet_id( @oldest_tweet_id,1 )
      @has_next = older_status.length > 0
    else
      @oldest_tweet_id = false
    end
  end

  def public_timeline
    # shows the public timeline
    @title = "パブリックタイムライン"
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
    @count_statuses = @current_user.statuses.count
    @count_friends = @current_user.friends.count
    @status_updated_at = Time.zone.at(@current_user.statuses_updated_at).strftime('%F %T')

    @friend_updated_at = @current_user.friends_updated_at
    if @friend_updated_at == 0
      @friend_updated_at = "---"
    else
      @friend_updated_at = Time.zone.at(@friend_updated_at).strftime('%F %T')
    end
    @profile_updated_at = Time.zone.at(@current_user.updated_at).strftime('%F %T')
  end

  def delete_account
  end

end

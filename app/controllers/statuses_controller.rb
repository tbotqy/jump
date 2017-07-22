# -*- coding: utf-8 -*-
class StatusesController < ApplicationController

  before_filter :check_login,        except: :public_timeline
  before_filter :check_tweet_import, except: [:import, :public_timeline]

  def import
    # show the screen for operating import method

    # redirect initialized user
    if @current_user.has_imported?
      redirect_to "/your/tweets" and return
    end

    # check if user has any status
    @id_oldest = "false";
    @count_so_far = "false";
    if @current_user.has_any_status?
      # this means that importing was stopped on its way
      @id_oldest = @current_user.get_oldest_active_tweet_id
      @count_so_far = @current_user.get_active_status_count
    end

    # get the total number of tweets user has on twitter
    user_twitter = create_twitter_client.user(@current_user.twitter_id)
    @statuses_count = user_twitter.attrs[:statuses_count]
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

end

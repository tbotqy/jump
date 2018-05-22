# -*- coding: utf-8 -*-
class AjaxController < ApplicationController
  before_action :reject_non_ajax
  before_action :check_login, :except => ['reject_non_ajax','get_dashbord','read_more','switch_term']
  layout false

  def reject_non_ajax
    redirect_to :status => :method_not_allowed  unless request.xhr?
  end

  def check_profile_update
    ret = {}

    values_to_check = ['name','screen_name','profile_image_url_https','time_zone','utc_offset','lang']
    fresh_data = create_twitter_client.user(@current_user.twitter_id)
    existing_data = @current_user.attributes

    updated = false
    updated_value = {}
    # check for each value
    values_to_check.each do |value_name|
      new_data = fresh_data[value_name].to_s
      if new_data != existing_data[value_name].to_s
        # udpate db with fresh data
        @current_user.update_attribute(value_name,new_data)
        updated = true
        updated_value[value_name] = new_data
      end
    end

    ret[:updated] = updated
    ret[:updated_value] = updated_value
    ret[:updated_date] = Time.zone.at(@current_user.updated_at.to_i).strftime('%F %T')

    render :json => ret
  end

  def check_status_update
    # just check if status can be updated
    ret = {}

    api_params = {:user_id => @current_user.id, :count => 1, :include_rts => true}

    # check if new status exists by comparing posted time
    latest_tweet = create_twitter_client.user_timeline(@current_user.screen_name.to_s, api_params)
    fresh_latest_created_at = Time.zone.parse(latest_tweet[0][:attrs][:created_at].to_s).to_i

    existing_latest_status = Status.showable.get_latest_status(1).owned_by_current_user(@current_user.id)
    if existing_latest_status.length > 0
      existing_latest_created_at = existing_latest_status.pluck(:twitter_created_at)[0]
    else
      existing_latest_created_at = 0
    end

    # if fresh data's timestamp is greater than existing one, answers true
    ret['do_update'] = fresh_latest_created_at.to_i > existing_latest_created_at

    unless ret['do_update']
      # mark current time
      checked_at = Time.zone.now
      User.find(@current_user.id).update_attribute(:statuses_updated_at,checked_at.to_i)
      ret['checked_at'] = checked_at.strftime("%F %T")
    end

    render :json => ret
  end

  def check_friend_update
    # initialization
    ret = {}
    do_update = false

    # fetch the list of user's friends
    existing_friend_ids = Friend.get_friend_twitter_ids(@current_user.id)
    fresh_friend_ids = fetch_friend_list_by_twitter_id(@current_user.twitter_id)

    # check if update is required by comparing
    do_update = existing_friend_ids.sort! != fresh_friend_ids.sort!

    if do_update
      Friend.update_list(@current_user.id,fresh_friend_ids)
    else
      # just update timestamp
      @current_user.update_attribute(:friends_updated_at,Time.now.to_i)
    end

    ret = {
      :updated => do_update,
      :friends_count => @current_user.friends.count,
      :updated_date => Time.zone.at(@current_user.friends_updated_at).strftime('%F %T')
    }

    render :json => ret
  end

  def deactivate_account
    ret = {}

    if User.deactivate_account(@current_user.id)
      deleted = true
    end

    sleep 3

    ret[:deleted] = deleted
    render :json => ret
  end

  def delete_account
    ret = {}
    dest_id = params[:dest_id]

    # deletes all the associated data
    if User.find(dest_id).destroy
      ret[:result] = true
    else
      ret[:result] = false
    end

    render :json => ret
  end

  def delete_status
    ret = {}
    status_id = params[:status_id_to_delete]
    deleted = false;
    owns = false;

    # check if user owns the status with given status_id
    if Status.where(:user_id => @current_user.id,:id => status_id).exists?
      # delete the status and turn the flag
      if Status.find(status_id).destroy
        # update stats
        DataSummary.decrease('active_status_count',1)

        deleted = true
        owns = true
      end
    end

    ret[:deleted] = deleted
    ret[:owns] = owns

    render :json => ret
  end

  def update_status
    # initialization
    count_saved = 0
    continue = true
    oldest_id_str = ""
    updated_date = ""

    # set basic params to retrieve tweets via api
    api_params = { :include_rts => true, :include_entities => true }

    # this is the oldest tweet's id of the statuses that have imported so far
    max_id = params[:oldest_id_str].presence || false

    if max_id
      # set params to acquire 101 statuses that are older than the status with max_id
      api_params[:count] = 101
      api_params[:max_id] = max_id
      statuses = create_twitter_client.user_timeline(@current_user.screen_name.to_s, api_params)

      # remove the newest status from result because it has been already saved in previous ajax call
      if statuses.size > 0
        statuses.shift
      end
    else
      # acqurie 100 tweets
      api_params[:count] = 100
      user_twitter = create_twitter_client.user(@current_user.twitter_id)
      statuses = create_twitter_client.user_timeline(@current_user.screen_name.to_s, api_params)
    end

    if statuses.present?

      oldest_id_str = statuses.last[:attrs][:id_str]

      # check latest status's tweeted time
      existing_latest_status = Status.get_latest_status(1).owned_by_current_user(@current_user.id)[0]

      if existing_latest_status
        existing_latest_unixtime = ( Status.get_latest_status(1).owned_by_current_user(@current_user.id)[0] ).twitter_created_at
      else
        existing_latest_unixtime = 0
      end

      saved_count = 0
      if existing_latest_unixtime > 0
        # only save the tweets that have not been saved yet
        statuses.each do |tweet|
          if Time.parse(tweet.created_at.to_s).to_i > existing_latest_unixtime.to_i
            Status.save_statuses!(@current_user.id,tweet)
            saved_count += 1
          else
            # stop saving
            continue = false
          end
        end

      else
        # just save all the tweets
        Status.save_statuses!(@current_user.id,statuses)
        saved_count = statuses.size
      end

    else
      continue = false
    end

    # update stats
    DataSummary.increase('active_status_count',saved_count)

    # prepare data to return
    ret = {}
    ret[:continue] = continue
    ret[:saved_count] = saved_count.to_i
    ret[:oldest_id_str] = oldest_id_str
    ret[:updated_date] = Time.zone.at(@current_user.updated_at.to_i).strftime('%F %T')

    render :json => ret
  end

  def read_more
    @oldest_tweet_id = params[:oldest_tweet_id]
    destination_action_type = params[:destination_action_type]

    @statuses = nil
    @has_next = false

    fetch_num = 10 # shows 10 statuses at one request
    request_fetch_num = fetch_num +1 # requests +1 statuses to check if more statuses exist

    # fetch older statuses
    case destination_action_type.to_s
    when 'user_timeline'
      @statuses = Status.showable.get_older_status_by_tweet_id(@oldest_tweet_id,request_fetch_num).owned_by_current_user(@current_user.id)
    when 'home_timeline'
      @statuses = Status.showable.force_index(:idx_u_on_statuses).owned_by_friend_of(@current_user.id).get_older_status_by_tweet_id(@oldest_tweet_id,request_fetch_num)
    when 'public_timeline'
      @statuses = Status.showable.get_older_status_by_tweet_id(@oldest_tweet_id,request_fetch_num)
    end

    @statuses = @statuses.to_a

    # check if any older status exists
    if @statuses.count != request_fetch_num
      @has_next = false
    else
      @statuses.pop
      @has_next = true
    end
    @oldest_tweet_id = @statuses.last.status_id_str
  end

  def get_dashbord

    @action_type = params[:action_type]

    raise "action type is not specified" if !@action_type

    @date_list = Status.showable.get_date_list(@action_type,@current_user.try!(:id))

    @base_url = ""
    case @action_type
    when 'public_timeline'
      @base_url = "/public_timeline"
    when 'user_timeline'
      @base_url = "/user_timeline"
    when 'home_timeline'
      @base_url = "/home_timeline"
    end
  end

  def make_initial_import
    TweetImportJob.perform_later(user_id: @current_user.id)
    FriendImportJob.perform_later(user_id: @current_user.id)
    head :accepted
  end

  def start_tweet_import
    TweetImportJob.perform_later(user_id: @current_user.id)
    head :accepted
  end

  def check_import_progress
    render json: AjaxViewObject::CheckImportProgress.new(user_id: @current_user.id).as_hash
  end

  def switch_term

    action_type = params[:action_type]
    date = params[:date]
    date = nil if date == "notSpecified"
    @has_next = false

    fetch_num = 10
    case action_type
    when 'user_timeline'
      if date
        @statuses = Status.showable.get_status_in_date(date,fetch_num).owned_by_current_user(@current_user.id)
      else
        @statuses = Status.showable.get_latest_status(fetch_num).owned_by_current_user(@current_user.id)
      end
      if @statuses.present?
        older_status = Status.showable.get_older_status_by_tweet_id( @statuses.last.status_id_str,1 ).owned_by_current_user(@current_user.id)
        @has_next = older_status.length > 0
      end
    when 'home_timeline'
      if date
        @statuses = Status.showable.get_status_in_date(date,fetch_num).owned_by_friend_of(@current_user.id)
      else
        @statuses = Status.showable.use_index(:idx_u_tcar_sisr_on_statuses).get_latest_status(fetch_num).owned_by_friend_of(@current_user.id)
      end
      if @statuses.present?
        older_status = Status.showable.force_index(:idx_u_on_statuses).owned_by_friend_of(@current_user.id).get_older_status_by_tweet_id( @statuses.last.status_id_str,1 )
        @has_next = older_status.length > 0
      end
    when 'public_timeline'
        if date
          @statuses = Status.showable.get_status_in_date(date,fetch_num)
        else
          @statuses = Status.showable.get_latest_status(fetch_num)
        end

      if @statuses.present?
        older_status = Status.showable.get_older_status_by_tweet_id( @statuses.last.status_id_str,1 )
        @has_next = older_status.length > 0
      end

    end

    if @statuses.present?
      # get the oldest tweet's posted timestamp
      @oldest_tweet_id = @statuses.last.status_id_str
    else
      @oldest_tweet_id = false
    end

  end
end

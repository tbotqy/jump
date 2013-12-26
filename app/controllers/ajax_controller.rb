# -*- coding: utf-8 -*-
class AjaxController < ApplicationController

  before_filter :reject_non_ajax
  before_filter :check_login, :except => ['reject_non_ajax','get_dashbord','read_more','switch_term']
  layout false

  def reject_non_ajax
    redirect_to :status => :method_not_allowed  unless request.xhr?
  end

  def check_profile_update
    ret = {}

    values_to_check = ['name','screen_name','profile_image_url_https','time_zone','utc_offset','lang']
    fresh_data = create_twitter_client.user(@@current_user.twitter_id)
    existing_data = @@current_user.attributes
    
    updated = false
    updated_value = {}
    # check for each value
    values_to_check.each do |value_name|
      new_data = fresh_data[value_name]
      if new_data != existing_data[value_name]
        # udpate db with fresh data
        @@current_user.update_attribute(value_name,new_data)
        updated = true
        updated_value[value_name] = new_data
      end
    end
    
    ret[:updated] = updated     
    ret[:updated_value] = updated_value
    ret[:updated_date] = Time.zone.at(@@current_user.updated_at.to_i).strftime('%F %T')
    
    render :json => ret
  end

  def check_status_update
    # just check if status can be updated
    ret = {}

    api_params = {:user_id => @@user_id, :count => 1, :include_rts => true}
    
    # check if new status exists by comparing posted time
    latest_tweet = create_twitter_client.user_timeline(@@current_user.screen_name.to_s, api_params)
    fresh_latest_created_at = Time.zone.parse(latest_tweet[0][:attrs][:created_at].to_s).to_i
    
    existing_latest_status = Status.find(:first,:select => 'twitter_created_at',:order => 'twitter_created_at DESC')
    if existing_latest_status
      existing_latest_created_at = existing_latest_status.twitter_created_at.to_i
    else
      existing_latest_created_at = 0
    end
    
    # if fresh data's timestamp is greater than existing one, answers true
    ret['do_update'] = fresh_latest_created_at.to_i > existing_latest_created_at
    
    unless ret['do_update']
      # mark current time
      checked_at = Time.zone.now
      User.find(@@user_id).update_attribute(:statuses_updated_at,checked_at.to_i)
      ret['checked_at'] = checked_at.strftime("%F %T")
    end
    
    render :json => ret 
  end

  def check_friend_update
    # initialization
    ret = {}
    do_update = false
    
    # fetch the list of user's friends
    existing_friend_ids = Friend.get_list.owned_by_current_user(@@user_id).pluck(:following_twitter_id)
    fresh_friend_ids = fetch_friend_list_by_twitter_id(@@current_user.twitter_id)
    
    # check if update is required by comparing 
    do_update = existing_friend_ids.sort! != fresh_friend_ids.sort!
    
    if do_update
      Friend.update_list(@@user_id,fresh_friend_ids)
    else
      # just update timestamp
      @@current_user.update_attribute(:friends_updated_at,Time.now.to_i)
    end

    ret = {
      :updated => do_update,
      :friends_count => @@current_user.friends.count,
      :updated_date => Time.zone.at(@@current_user.friends_updated_at).strftime('%F %T')
    }
    
    render :json => ret
  end
          
  def deactivate_account
    ret = {}

    if User.deactivate_account(@@user_id)
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
    if Status.where(:user_id => @@user_id,:id => status_id).exists?
      
      # delete the status and turn the flag
      if Status.find(status_id).destroy
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
      statuses = create_twitter_client.user_timeline(@@current_user.screen_name.to_s, api_params)
      
      # remove the newest status from result because it has been already saved in previous ajax call
      if statuses.size > 0
        statuses.shift
      end
    else
      Status.delete_pre_saved_status(@@user_id.to_i)
      
      # acqurie 100 tweets
      api_params[:count] = 100
      user_twitter = create_twitter_client.user(@@current_user.twitter_id)
      statuses = create_twitter_client.user_timeline(@@current_user.screen_name.to_s, api_params)
    end
    
    if statuses.present?

      oldest_id_str = statuses.last[:attrs][:id_str]

      # check latest status's tweeted time
      existing_latest_status = Status.get_latest_status(1).owned_by_current_user(@@user_id)[0]
  
      if existing_latest_status
        existing_latest_unixtime = ( Status.get_latest_status(1).owned_by_current_user(@@user_id)[0] ).twitter_created_at
      else
        existing_latest_unixtime = 0
      end

      saved_count = 0
      if existing_latest_unixtime > 0
        # only save the tweets that have not been saved yet
        statuses.each do |tweet|
          if Time.parse(tweet.created_at.to_s).to_i > existing_latest_unixtime.to_i
            Status.save_single_status(@@user_id,tweet)
            saved_count += 1
          else
            # stop saving
            continue = false
          end
        end
        
      else
        # just save all the tweets
        Status.save_statuses(@@user_id,statuses)
        saved_count = statuses.size
      end

    else
      continue = false
    end

    if !continue
      # make pre-saved statuses saved
      Status.save_pre_saved_status(@@user_id)
    end

    # prepare data to return
    ret = {}
    ret[:continue] = continue
    ret[:saved_count] = saved_count.to_i
    ret[:oldest_id_str] = oldest_id_str
    ret[:updated_date] = Time.zone.at(@@current_user.updated_at.to_i).strftime('%F %T')
    
    render :json => ret
  end

  def read_more
    @oldest_tweet_id = params[:oldest_tweet_id]
    destination_action_type = params[:destination_action_type]
 
    @statuses = nil
    @has_next = false
   
    fetch_num = 10 # fetches 10 statuses at one request

    # fetch older statuses 
    case destination_action_type.to_s
    when 'tweets'
      @statuses = Status.get_older_status_by_tweet_id(@oldest_tweet_id,fetch_num).owned_by_current_user(@@user_id)
    when 'home_timeline'
      @statuses = Status.get_older_status_by_tweet_id(@oldest_tweet_id,fetch_num).owned_by_friend_of(@@user_id)
    when 'public_timeline'
      @statuses = Status.get_older_status_by_tweet_id(@oldest_tweet_id,fetch_num).owned_by_active_user
    end

    # check if any older status exists
    if @statuses.count != fetch_num
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

    @date_list = Status.get_date_list(@action_type,@@user_id)
    
    @base_url = ""
    case @action_type
    when 'public_timeline'
      @base_url = "/public_timeline"
    when 'sent_tweets'
      @base_url = "/your/tweets"
    when 'home_timeline'
      @base_url = "/your/home_timeline"
    end
  end
  
  def acquire_statuses
    # calls twitter api to retrieve user's twitter statuses and returns json

    # initialize values
    no_status_at_all = false
    continue = false
    statuses = nil
    
    redirect_to :status => :method_not_allowed  unless request.post?
  
    # set basic params to retrieve tweets via api
    api_params = { :include_rts => true, :include_entities => true }

    # this is the oldest tweet's id of the statuses that have imported so far    
    max_id = params[:id_str_oldest].presence || false
    
    if max_id
      # set params to acquire 101 statuses that are older than the status with max_id
      api_params[:count] = 101
      api_params[:max_id] = max_id
      
      statuses = create_twitter_client.user_timeline(@@current_user.screen_name.to_s, api_params)
      
      # remove the newest status from result because it has been already saved in previous ajax call
      if statuses.size > 0
        statuses.shift
      end
    else
      # acqurie 100 tweets
      api_params[:count] = 100
      statuses = create_twitter_client.user_timeline(@@current_user.screen_name.to_s, api_params)
      # retrieve following list and save them as user's friend
      friends = fetch_friend_list_by_twitter_id(@@current_user.twitter_id)
      Friend.save_friends(@@user_id.to_i,friends)
      
      if !statuses
        no_status_at_all = true
      end
    end
    
    # save
    saved_count = statuses.size
    if saved_count > 0
      # clean the pre saved statuses up
      Status.delete_pre_saved_status(@@user_id.to_i)
      # save statuses with pre_saved_flags set to true
      Status.save_statuses(@@user_id.to_i,statuses)
      # turn all the statuses' pre_saved_flag false
      Status.save_pre_saved_status(@@user_id.to_i)
      continue = true
    else
      continue = false
    end

    # prepare data to return
    ret = {}

    ret[:continue] = continue
    ret[:saved_count] = saved_count
    ret[:no_status_at_all] = no_status_at_all

    if continue
      # show the user one of his tweets
      last_status = statuses.pop
      text = last_status[:attrs][:text]
      id_str_oldest = last_status[:attrs][:id_str]
      created_at = Time.parse(last_status[:attrs][:created_at]).strftime("%Y年%m月%d日 - %H:%M")
      
      ret[:id_str_oldest] = id_str_oldest
      ret[:status] = {:date =>created_at,:text=>text}
    else
      unless no_status_at_all
        # mark this user as initialized
        User.find(@@user_id.to_i).update_attribute(:initialized_flag,true)
      end
      # send notification dm
      create_twitter_client(configatron.access_token,configatron.access_token_secret) do |my_twitter|
        my_twitter.direct_message_create(configatron.admin_user_twitter_id, "@"+ @@current_user.screen_name.to_s + "has joined at " + Time.now)
      end
      # send notification dm
      admin_twitter = create_twitter_client(configatron.access_token,configatron.access_token_secret)
      admin_twitter.direct_message_create(configatron.service_owner_twitter_id.to_i, "@"+ @@current_user.screen_name.to_s + " has joined at " + Time.now.strftime('%F %T')) rescue nil
    end
    
    render :json => ret
  end
  
  def switch_term
    
    action_type = params[:action_type]
    date = params[:date]
    date = nil if date == "notSpecified"
    @has_next = false

    fetch_num = 10
    case action_type
    when 'tweets'
      if date
        @statuses = Status.get_status_in_date(date,fetch_num).owned_by_current_user(@@user_id)
      else
        @statuses = Status.get_latest_status(fetch_num).owned_by_current_user(@@user_id)
      end
      @has_next = Status.get_older_status_by_tweet_id( @statuses.last.status_id_str ).owned_by_current_user(@@user_id).exists? if @statuses.present?
    when 'home_timeline'
      if date
        @statuses = Status.get_status_in_date(date,fetch_num).owned_by_friend_of(@@user_id)
      else
        @statuses = Status.get_latest_status(fetch_num).owned_by_friend_of(@@user_id)
      end
      @has_next = Status.get_older_status_by_tweet_id( @statuses.last.status_id_str ).owned_by_friend_of(@@user_id).exists? if @statuses.present?
    when 'public_timeline'
        if date
          @statuses = Status.get_status_in_date(date,fetch_num).owned_by_active_user
        else
          @statuses = Status.get_latest_status(fetch_num).owned_by_active_user
        end
      @has_next = Status.get_older_status_by_tweet_id( @statuses.last.status_id_str ).owned_by_active_user.exists? if @statuses.present? 
    end
    
    if @statuses.present?
      # get the oldest tweet's posted timestamp
      @oldest_tweet_id = @statuses.last.status_id_str
    else
      @show_footer = true
      @oldest_tweet_id = false
    end
  end
end

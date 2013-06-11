# -*- coding: utf-8 -*-
class AjaxController < ApplicationController

  before_filter :reject_non_ajax

  def reject_non_ajax
    redirect_to :status => :method_not_allowed  unless request.xhr?
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
      Status.delete_pre_saved_status(@@current_user.id.to_i)
      
      # acqurie 100 tweets
      api_params[:count] = 100
      user_twitter = create_twitter_client.user(@@current_user.twitter_id)
      statuses = create_twitter_client.user_timeline(@@current_user.screen_name.to_s, api_params)

      # retrieve following list and save them as user's friend
      friends = create_twitter_client.friend_ids(@@current_user.screen_name.to_s, {:stringify_ids=>true}).all
      Friend.save_friends(@@current_user.id.to_i,friends)
      
      if !statuses
        no_status_at_all = true
      end
    end
    
    # save
    saved_count = statuses.size
    if saved_count > 0
      Status.save_statuses(@@current_user.id.to_i,statuses)
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
        User.find(@@current_user.id.to_i).update_attribute(:initialized_flag,true)
        
        # make pre-saved statuses saved
        Status.save_pre_saved_status(@@current_user.id.to_i)
      end
    end
    
    render :json => ret
  end

  def read_more
    @oldest_timestamp = params[:oldest_timestamp]
    destination_action_type = params[:destination_action_type]
 
    @statuses = nil
    @has_next = false
   
    fetch_num = 10 # fetches 10 statuses at one request
    _fetch_num = fetch_num + 1 # plus 1 to check if 'read more buttton' should be shown in the view

    # fetch older statuses    
    case destination_action_type.to_s
    when 'tweets'
      @statuses = Status.get_status_older_than(@oldest_timestamp,_fetch_num).owned_by_current_user(@current_user.id)
    when 'home_timeline'
      @statuses = Status.get_status_older_than(@oldest_timestamp,_fetch_num).owned_by_friend_of(@current_user.id)
    when 'public_timeline'
      @statuses = Status.get_status_older_than(@oldest_timestamp,_fetch_num).owned_by_active_user
    end

    # check if any older status exists
    if @statuses.count != _fetch_num
      @has_next = false
    else
      @statuses.pop
      @has_next = true
    end
    @oldest_timestamp = @statuses.last.twitter_created_at
    
    render :layout => false
  end
end

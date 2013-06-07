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
      
      statuses = create_twitter_client.user_timeline(@@current_user.screen_name, api_params)
      
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
      friends = create_twitter_client.friend_ids(@@current_user.screen_name, {:stringify_ids=>true}).all
      Friend.save_friends(@@current_user.id,friends)
      
      if !statuses
        no_status_at_all = true
      end

    end
    
    # save
    saved_count = statuses.size
    if saved_count > 0
      Status.save_statuses(@@current_user,statuses)
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
      ret[:status] = [:date =>created_at,:text=>text]
    else
      
      unless no_status_at_all
        
        # mark this user as initialized
        User.find(@@current_user.id).update_attribute( :initialized_flag => true)
        
        # make pre-saved statuses saved
        Status.save_pre_saved_status(@@current_user.id)

      end
    end

    render :json => ret
    
  end
  
end

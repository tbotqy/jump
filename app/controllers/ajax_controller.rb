class AjaxController < ApplicationController
  before_action :reject_non_ajax
  before_action :check_login, :except => ['reject_non_ajax','term_selector','read_more','switch_term']
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

  def check_friend_update
    # initialization
    ret = {}
    do_update = false

    # fetch the list of user's friends
    existing_friend_ids = FollowingTwitterId.get_friend_twitter_ids(@current_user.id)
    fresh_friend_ids = fetch_friend_list_by_twitter_id(@current_user.twitter_id)

    # check if update is required by comparing
    do_update = existing_friend_ids.sort! != fresh_friend_ids.sort!

    if do_update
      FollowingTwitterId.update_list(@current_user.id,fresh_friend_ids)
    else
      # just update timestamp
      @current_user.update_attribute(:friends_updated_at,Time.now.to_i)
    end

    ret = {
      :updated => do_update,
      :friends_count => @current_user.friend_count,
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
        ActiveStatusCount.decrement

        deleted = true
        owns = true
      end
    end

    ret[:deleted] = deleted
    ret[:owns] = owns

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
      @statuses = Status.not_deleted.get_older_status_by_tweet_id(@oldest_tweet_id,request_fetch_num).tweeted_by(@current_user.id)
    when 'home_timeline'
      @statuses = Status.not_deleted.not_private.force_index(:idx_u_on_statuses).tweeted_by_friend_of(@current_user.id).get_older_status_by_tweet_id(@oldest_tweet_id,request_fetch_num)
    when 'public_timeline'
      @statuses = Status.not_deleted.not_private.get_older_status_by_tweet_id(@oldest_tweet_id,request_fetch_num)
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

  def term_selector
    timeline_type = TimelineType.new(params[:action_type])
    @view_object = AjaxViewObject::TermSelector.new(timeline_type, @current_user&.id)
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
    timeline = case params[:action_type]
    when 'user_timeline'
      Timeline::UserTimeline.new(params[:date], @current_user)
    when 'home_timeline'
      Timeline::HomeTimeline.new(params[:date], @current_user)
    when 'public_timeline'
      Timeline::PublicTimeline.new(params[:date])
    end

    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end
end

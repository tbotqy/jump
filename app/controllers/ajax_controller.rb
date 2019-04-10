# frozen_string_literal: true

class AjaxController < ApplicationController
  before_action :reject_non_ajax
  before_action :authenticate_user!, except: ["reject_non_ajax", "term_selector", "read_more", "switch_term"]
  layout false

  def check_profile_update
    ret = {}

    values_to_check = ["name", "screen_name", "profile_image_url_https", "time_zone", "utc_offset", "lang"]
    fresh_data = TwitterRestClient.by_user_id(current_user.id).user(current_user.twitter_id)
    existing_data = current_user.attributes

    updated = false
    updated_value = {}
    # check for each value
    values_to_check.each do |value_name|
      new_data = fresh_data[value_name].to_s
      if new_data != existing_data[value_name].to_s
        # udpate db with fresh data
        current_user.update_attribute(value_name, new_data)
        updated = true
        updated_value[value_name] = new_data
      end
    end

    ret[:updated] = updated
    ret[:updated_value] = updated_value
    ret[:updated_date] = Time.zone.at(current_user.updated_at.to_i).strftime("%F %T")

    render json: ret
  end

  def check_friend_update
    PullFolloweesService.call!(user_id: current_user.id)

    ret = {
      friends_count: current_user.friend_count,
      updated_date: Time.zone.at(current_user.friends_updated_at).strftime("%F %T")
    }

    render json: ret
  end

  def deactivate_account
    ret = {}

    if User.deactivate_account(current_user.id)
      deleted = true
    end

    sleep 3

    ret[:deleted] = deleted
    render json: ret
  end

  def delete_status
    ret = {}
    status_id = params[:status_id_to_delete]
    deleted = false
    owns = false

    # check if user owns the status with given status_id
    if Status.where(user_id: current_user.id, id: status_id).exists?
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

    render json: ret
  end

  def read_more
    timeline_type = TimelineType.new(params[:destination_action_type])
    timeline = Timeline.read_more(
      type: timeline_type,
      prev_oldest_tweet_id: params[:oldest_tweet_id].to_i,
      timeline_owner: current_user
               )

    @statuses        = timeline.source_statuses
    @has_next        = timeline.has_next?
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

  def term_selector
    timeline_type = TimelineType.new(params[:action_type])
    @view_object = AjaxViewObject::TermSelector.new(timeline_type, current_user&.id)
  end

  def make_initial_import
    TweetImportJob.perform_later(user_id: current_user.id)
    FriendImportJob.perform_later(user_id: current_user.id)
    head :accepted
  end

  def start_tweet_import
    TweetImportJob.perform_later(user_id: current_user.id)
    head :accepted
  end

  def check_import_progress
    render json: AjaxViewObject::CheckImportProgress.new(user_id: current_user.id).as_hash
  end

  def switch_term
    timeline = Timeline.by_type_and_date(
      type: TimelineType.new(params[:action_type]),
      date: params[:date],
      timeline_owner: current_user
               )

    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

  private

    def reject_non_ajax
      redirect_to status: :method_not_allowed unless request.xhr?
    end
end

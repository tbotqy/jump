class StatusesController < ApplicationController

  before_action :check_login,        except: :public_timeline
  before_action :check_tweet_import, except: [:import, :public_timeline]

  # show the screen for operating import
  def import
    # redirect initialized user
    return redirect_to action: :user_timeline if @current_user.finished_initial_import?

    @working_job_exists = @current_user.has_working_job?
    @expected_total_import_count = TwitterServiceClient::UserTweet.maximum_fetchable_tweet_count(user_id: @current_user.id)
  end

  def user_timeline
    # shows the tweets tweeted by logged-in user

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @current_user

    timeline = Timeline::UserTimeline.new(params[:date], @timeline_owner)
    @title           = timeline.title
    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

  def home_timeline
    # shows the home timeline

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @current_user

    timeline = Timeline::HomeTimeline.new(params[:date], @timeline_owner)
    @title           = timeline.title
    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

  def public_timeline
    # TODO : reduce the number of instance vars
    timeline         = Timeline::PublicTimeline.new(params[:date])
    @title           = timeline.title
    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

end

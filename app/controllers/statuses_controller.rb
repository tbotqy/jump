class StatusesController < ApplicationController

  before_filter :check_login,        except: :public_timeline
  before_filter :check_tweet_import, except: [:import, :public_timeline]

  # show the screen for operating import
  def import
    # redirect initialized user
    return redirect_to action: :sent_tweets if @current_user.has_imported?

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

    timeline = Timeline::UserTimeline.new(params, @timeline_owner)
    @title           = timeline.title
    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

  def home_timeline
    # shows the home timeline

    # this line may be changed when the page is published to not-loggedin visitors
    @timeline_owner = @current_user

    timeline = Timeline::HomeTimeline.new(params, @timeline_owner)
    @title           = timeline.title
    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

  def public_timeline
    # TODO : reduce the number of instance vars
    timeline         = Timeline::PublicTimeline.new(params)
    @title           = timeline.title
    @has_next        = timeline.has_next?
    @statuses        = timeline.source_statuses
    @oldest_tweet_id = timeline.oldest_tweet_id
  end

end

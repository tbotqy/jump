class ImportTweetsService
  private_class_method :new

  class << self
    def call!(user_id:)
      new(user_id).call!
    end
  end

  private

  def initialize(user_id)
    @user_id = user_id
  end

  def call!
    determine_smallest_tweet_id_to_fetch!
    fetch_and_register!
    close_progress!
    update_summary
    user.finish_initial_import!
  end

  def determine_smallest_tweet_id_to_fetch!
    # MEMO : this method is intended to be called under these conditions
    # - only once
    # - before #process! is called

    # raise if this method seems to be called in several times
    raise "This method is intended to be called only once." if defined?(@smallest_tweet_id_to_fetch)
    if user.has_any_status?
      @smallest_tweet_id_to_fetch = user.status_newest_in_tweeted_time.status_id_str + 1
    else
      @smallest_tweet_id_to_fetch = nil
    end
  end

  def fetch_and_register!
    largest_tweet_id_to_fetch = nil
    loop do
      tweets = TwitterServiceClient::UserTweet.fetch_tweets_with_id_range!(user_id: @user_id, smallest_tweet_id: @smallest_tweet_id_to_fetch, largest_tweet_id: largest_tweet_id_to_fetch)
      break if tweets.blank?
      save_tweets!(tweets)
      record_progress!(tweets.count)
      # specify for subsequent fetch
      largest_tweet_id_to_fetch = tweets.last.id - 1
    end
  end

  def save_tweets!(tweets)
    Status.save_tweets!(@user_id, tweets)
  end

  def record_progress!(tweet_count_additionally_imported)
    job_progress.increment_count!(by: tweet_count_additionally_imported)
  end

  def close_progress!
    job_progress.mark_as_finished!
  end

  def update_summary
    ActiveStatusCount.increment_by(job_progress.count)
  end

  def job_progress
    @job_progress ||= TweetImportJobProgress.new(job_id: job_id, user_id: @user_id)
  end

  def user
    @user ||= User.find(@user_id)
  end
end

# frozen_string_literal: true

class TweetImportJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    determine_smallest_tweet_id_to_fetch!
    process!
  end

  private
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

    def process!
      largest_tweet_id_to_fetch = nil
      loop do
        tweets = FetchUserTweetsByIdRangeService.call!(user_id: @user_id, min_tweet_id: @smallest_tweet_id_to_fetch, max_tweet_id: largest_tweet_id_to_fetch)
        break if tweets.blank?
        save_tweets!(tweets)
        record_progress!(tweets.count)
        # specify for subsequent fetch
        largest_tweet_id_to_fetch = tweets.last.id - 1
      end
      close_progress!
      update_summary
      user.finish_initial_import!
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
      @job_progress ||= TweetImportJobProgress.new(job_id: job_id, user_id: @user_id, percentage_denominator: maximum_fetchable_tweet_count)
    end

    def user
      @user ||= User.find(@user_id)
    end

    def maximum_fetchable_tweet_count
      @maximum_fetchable_tweet_count ||= TwitterServiceClient::UserTweet.maximum_fetchable_tweet_count(user_id: @user_id)
    end
end

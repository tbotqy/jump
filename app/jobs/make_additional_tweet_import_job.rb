# frozen_string_literal: true

class MakeAdditionalTweetImportJob < ApplicationJob
  include UserTwitterClient
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    @most_recent_tweet_id = nil
    @imported_tweets      = []
    acquire_job_lock!
    begin
      ensure_additional_import!
      fetch_most_recent_tweet_id!
      operate!
    ensure
      release_job_lock!
    end
  end

  private
    attr_reader :user_id, :most_recent_tweet_id, :imported_tweets

    def ensure_additional_import!
      unless user.has_any_status?
        raise "This job is intended to be called for additional import, but user has no status."
      end
    end

    def fetch_most_recent_tweet_id!
      @most_recent_tweet_id = user.statuses.most_recent_tweet_id!
    end

    def operate!
      ActiveRecord::Base.transaction do
        import!
        finalize!
      end
    end

    def import!
      @imported_tweets = user_twitter_client.collect_tweets_in_batches(after_id: most_recent_tweet_id) do |tweets|
        tweets.each { |tweet| RegisterTweetService.call!(tweet: tweet) }
      end
    end

    def finalize!
      user.update!(statuses_updated_at: Time.current.to_i)
      ActiveStatusCount.increment_by(imported_tweets.count)
    end

    def acquire_job_lock!
      if user.tweet_import_lock.present?
        raise "The job has been locked."
      else
        user.create_tweet_import_lock!
      end
    end

    def release_job_lock!
      user.tweet_import_lock.destroy!
    end

    def user
      @user ||= User.find(user_id)
    end
end

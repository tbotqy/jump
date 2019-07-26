# frozen_string_literal: true

class MakeAdditionalTweetImportJob < ApplicationJob
  include UserTwitterClient
  queue_as :default

  def perform(user_id:)
    @user_id              = user_id
    @most_recent_tweet_id = nil
    @imported_tweets      = []

    ensure_additional_import!
    fetch_most_recent_tweet_id!
    operate!
  end

  private
    attr_reader :user_id, :most_recent_tweet_id, :imported_tweets

    def ensure_additional_import!
      unless user.statuses.exists?
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
      user.update!(statuses_updated_at: Time.now.utc.to_i)
      ActiveStatusCount.increment_by(imported_tweets.count)
    end

    def user
      @user ||= User.find(user_id)
    end
end

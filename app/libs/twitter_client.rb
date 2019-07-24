# frozen_string_literal: true

class TwitterClient
  TWEET_COUNT_PER_GET = 200
  private_constant :TWEET_COUNT_PER_GET

  def initialize(user_id:)
    @user_id = user_id
  end

  def collect_tweets_in_batches(collection = [], after_id: nil, before_id: nil, &block)
    tweets = user_rest_client.user_timeline(timeline_api_params(after_id: after_id, before_id: before_id))
    return collection if tweets.blank?
    yield(tweets)     if block_given?
    collect_tweets_in_batches(collection + tweets, after_id: after_id, before_id: tweets.last.id, &block)
  end

  private
    attr_reader :user_id

    def timeline_api_params(after_id:, before_id:)
      max_id = before_id.present? ? before_id - 1 : nil
      {
        since_id:    after_id,
        max_id:      max_id,
        include_rts: true,
        count:       TWEET_COUNT_PER_GET
      }.compact
    end

    def user_rest_client
      @user_rest_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = Settings.twitter.consumer_key
        config.consumer_secret     = Settings.twitter.consumer_secret
        config.access_token        = user.access_token
        config.access_token_secret = user.access_token_secret
      end
    end

    def user
      @user ||= User.find(user_id)
    end
end

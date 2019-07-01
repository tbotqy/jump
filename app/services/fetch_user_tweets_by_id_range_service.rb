# frozen_string_literal: true

class FetchUserTweetsByIdRangeService
  private_class_method :new

  MAX_TWEETS_COUNT_PER_GET = 200
  private_constant :MAX_TWEETS_COUNT_PER_GET

  class << self
    def call!(user_id:, min_tweet_id:, max_tweet_id: nil)
      new(user_id, min_tweet_id, max_tweet_id).send(:call!)
    end
  end

  def initialize(user_id, min_tweet_id, max_tweet_id)
    @user_id      = user_id
    @min_tweet_id = min_tweet_id
    @max_tweet_id = max_tweet_id
  end

  private
    attr_reader :user_id, :min_tweet_id, :max_tweet_id

    def call!
      twitter_rest_client.user_timeline(twitter_id, api_params)
    end

    def api_params
      default_api_params
        .merge(since_id: min_tweet_id - 1)
        .merge(max_id:   max_tweet_id)
        .compact
    end

    def default_api_params
      {
        include_rts:      true,
        include_entities: true,
        count:            MAX_TWEETS_COUNT_PER_GET
      }
    end

    def twitter_rest_client
      TwitterRestClient.by_user_id(user_id)
    end

    def twitter_id
      @twitter_id ||= User.find(user_id).twitter_id
    end
end

# frozen_string_literal: true

module TwitterServiceClient
  class UserTweet
    class << self
      def fetch_tweets_with_id_range!(user_id:, smallest_tweet_id:, largest_tweet_id:)
        client = new(user_id)
        client.set_param(since_id: smallest_tweet_id - 1) unless smallest_tweet_id.nil?
        client.set_param(max_id: largest_tweet_id) unless largest_tweet_id.nil?
        client.get_user_timeline!
      end

      def maximum_fetchable_tweet_count(user_id:)
        total_tweet_count = TwitterRestClient.by_user_id(user_id).user.tweets_count
        return MAXIMUM_FETCHABLE_TWEET_COUNT if total_tweet_count >= MAXIMUM_FETCHABLE_TWEET_COUNT
        total_tweet_count
      end

      # debug method
      def fetch_latest_tweets!(user_id)
        new(user_id).get_user_timeline!
      end
    end

    MAX_TWEETS_COUNT_PER_GET = 200
    MAXIMUM_FETCHABLE_TWEET_COUNT = 3200
    private_constant :MAX_TWEETS_COUNT_PER_GET, :MAXIMUM_FETCHABLE_TWEET_COUNT

    def initialize(user_id)
      @user_id = user_id
      @params  = default_params
    end

    def set_param(param_hash)
      @params.merge!(param_hash)
    end

    def get_user_timeline!
      twitter_rest_client.user_timeline(user.twitter_id, @params)
    end

    private

      def twitter_rest_client
        @twitter_rest_client ||= TwitterRestClient.by_user_id(@user_id)
      end

      def user
        @user ||= User.find(@user_id)
      end

      def default_params
        {
          include_rts: true,
          include_entities: true,
          count: MAX_TWEETS_COUNT_PER_GET
        }
      end
  end
end

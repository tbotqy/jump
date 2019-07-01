# frozen_string_literal: true

module TwitterServiceClient
  class UserTweet
    class << self
      def maximum_fetchable_tweet_count(user_id:)
        total_tweet_count = TwitterRestClient.by_user_id(user_id).user.tweets_count
        return MAXIMUM_FETCHABLE_TWEET_COUNT if total_tweet_count >= MAXIMUM_FETCHABLE_TWEET_COUNT
        total_tweet_count
      end
    end

    MAXIMUM_FETCHABLE_TWEET_COUNT = 3200
    private_constant :MAXIMUM_FETCHABLE_TWEET_COUNT
  end
end

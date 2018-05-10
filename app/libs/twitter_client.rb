class TwitterClient
  class << self
    def fetch_tweets_with_id_range!(user_id: ,smallest_tweet_id: ,largest_tweet_id:)
      client = new(user_id)
      client.set_param(since_id: smallest_tweet_id - 1) unless smallest_tweet_id.nil?
      client.set_param(max_id: largest_tweet_id) unless largest_tweet_id.nil?
      client.get_user_timeline!
    end

    # debug method
    def fetch_latest_tweets!(user_id)
      new(user_id).get_user_timeline!
    end
  end

  MAX_TWEETS_COUNT_PER_GET = 200
  private_constant :MAX_TWEETS_COUNT_PER_GET

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
    @twitter_rest_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = configatron.consumer_key
      config.consumer_secret     = configatron.consumer_secret
      config.access_token        = user.token
      config.access_token_secret = user.token_secret
    end
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

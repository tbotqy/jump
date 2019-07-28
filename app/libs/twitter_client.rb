# frozen_string_literal: true

class TwitterClient
  TWEET_COUNT_PER_GET = 200

  FRIEND_API_INITIAL_CURSOR  = -1
  FRIEND_API_TERMINAL_CURSOR = 0
  # defined by the doc of twitter api. see: https://developer.twitter.com/en/docs/basics/cursoring

  private_constant :TWEET_COUNT_PER_GET, :FRIEND_API_INITIAL_CURSOR, :FRIEND_API_TERMINAL_CURSOR

  delegate :user, to: :user_rest_client, prefix: :twitter

  def initialize(access_token:, access_token_secret:)
    @access_token        = access_token
    @access_token_secret = access_token_secret
  end

  def collect_tweets_in_batches(collection = [], after_id: nil, before_id: nil, &block)
    tweets = user_rest_client.user_timeline(timeline_api_params(after_id: after_id, before_id: before_id))
    return collection if tweets.blank?
    yield(tweets)     if block_given?
    collect_tweets_in_batches(collection + tweets, after_id: after_id, before_id: tweets.last.id, &block)
  end

  def collect_followee_ids(ids = [], cursor = FRIEND_API_INITIAL_CURSOR)
    followees   = user_rest_client.friend_ids(cursor: cursor)
    ids        += followees.attrs[:ids]
    next_cursor = followees.attrs[:next_cursor]
    return ids if next_cursor == FRIEND_API_TERMINAL_CURSOR
    collect_followee_ids(ids, next_cursor)
  end

  private
    attr_reader :access_token, :access_token_secret

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
        config.access_token        = access_token
        config.access_token_secret = access_token_secret
      end
    end
end

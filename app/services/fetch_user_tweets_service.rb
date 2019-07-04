# frozen_string_literal: true

class FetchUserTweetsService
  private_class_method :new

  MAX_TWEETS_COUNT_PER_GET = 200
  private_constant :MAX_TWEETS_COUNT_PER_GET

  class << self
    def call!(user_id:, tweeted_after_id:, tweeted_before_id: nil)
      new(user_id, tweeted_after_id, tweeted_before_id).send(:call!)
    end
  end

  private
    def initialize(user_id, tweeted_after_id, tweeted_before_id)
      @user_id           = user_id
      @tweeted_after_id  = tweeted_after_id
      @tweeted_before_id = tweeted_before_id
    end

    attr_reader :user_id, :tweeted_after_id, :tweeted_before_id

    def call!
      twitter_rest_client.user_timeline(twitter_id, api_params)
    end

    def api_params
      max_id = tweeted_before_id.present? ? tweeted_before_id - 1 : nil
      default_api_params
        .merge(since_id: tweeted_after_id)
        .merge(max_id:   max_id)
        .compact
    end

    def default_api_params
      {
        include_rts: true,
        count:       MAX_TWEETS_COUNT_PER_GET
      }
    end

    def twitter_id
      @twitter_id ||= User.find(user_id).twitter_id
    end

    def twitter_rest_client
      TwitterRestClient.by_user_id(user_id)
    end
end

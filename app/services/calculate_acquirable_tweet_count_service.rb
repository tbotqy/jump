# frozen_string_literal: true

class CalculateAcquirableTweetCountService
  private_class_method :new

  TRACEABLE_TWEET_COUNT_LIMIT = 3200
  private_constant :TRACEABLE_TWEET_COUNT_LIMIT

  class << self
    def call!(user_id:)
      new(user_id).send(:call!)
    end
  end

  private
    def initialize(user_id)
      @user_id = user_id
    end

    attr_reader :user_id

    def call!
      [TRACEABLE_TWEET_COUNT_LIMIT, total_tweet_count].min
    end

    def total_tweet_count
      @total_tweet_count ||= TwitterRestClient.by_user_id!(user_id).user.tweets_count
    end
end

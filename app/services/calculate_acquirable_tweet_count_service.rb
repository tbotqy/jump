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
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def call!
      [TRACEABLE_TWEET_COUNT_LIMIT, not_imported_tweet_count].min
    end

    def not_imported_tweet_count
      return 0 if total_tweet_count <= existing_status_count
      total_tweet_count - existing_status_count
    end

    def total_tweet_count
      @total_tweet_count ||= TwitterRestClient.by_user_id(user_id).user.tweets_count
    end

    def existing_status_count
      @existing_status_count ||= User.find(user_id).statuses.count
    end
end

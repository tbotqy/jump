# frozen_string_literal: true

class FetchUserFolloweesService
  private_class_method :new
  INITIAL_CURSOR  = -1
  TERMINAL_CURSOR = 0
  private_constant :INITIAL_CURSOR, :TERMINAL_CURSOR
  # defined by the doc of twitter api. see: https://developer.twitter.com/en/docs/basics/cursoring

  class << self
    def call!(user_id:)
      new(user_id).send(:call!)
    end
  end

  private
    def initialize(user_id)
      @user_id     = user_id
      @next_cursor = INITIAL_CURSOR
    end

    attr_reader :user_id

    def call!
      fetch_followee_twitter_ids_all!
    end

    def fetch_followee_twitter_ids_all!
      followee_twitter_ids = []
      while @next_cursor != TERMINAL_CURSOR
        followees              = twitter_rest_client.friend_ids(cursor: @next_cursor)
        followee_twitter_ids  += followees.attrs[:ids]
        @next_cursor           = followees.attrs[:next_cursor]
      end
      followee_twitter_ids
    end

    def twitter_rest_client
      @twitter_rest_client ||= TwitterRestClient.by_user_id(user_id)
    end
end

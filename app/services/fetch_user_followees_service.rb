# frozen_string_literal: true

class FetchUserFolloweesService
  private_class_method :new

  class << self
    def call!(user_id:)
      new(user_id).send(:call!)
    end
  end

  private
    def initialize(user_id)
      @user_id              = user_id
      @next_cursor          = -1
      @followee_twitter_ids = []
    end

    attr_reader :user_id

    def call!
      fetch_followee_twitter_ids_all!
      @followee_twitter_ids
    end

    def fetch_followee_twitter_ids_all!
      while !@next_cursor.zero?
        followees              = twitter_rest_client.friend_ids(twitter_id, cursor: @next_cursor)
        @followee_twitter_ids += followees.attrs[:ids]
        @next_cursor           = followees.attrs[:next_cursor]
      end
    end

    def twitter_id
      @twitter_id ||= User.find(user_id).twitter_id
    end

    def twitter_rest_client
      @twitter_rest_client ||= TwitterRestClient.by_user_id(user_id)
    end
end

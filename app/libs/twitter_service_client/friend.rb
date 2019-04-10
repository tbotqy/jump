# frozen_string_literal: true

module TwitterServiceClient
  class Friend
    class << self
      def fetch_friend_twitter_ids(user_id:)
        new(user_id).friend_ids
      end
    end

    attr_reader :friend_ids

    def initialize(user_id)
      @user_id     = user_id
      @next_cursor = -1
      @friend_ids  = []
      fetch_friend_ids_all!
    end

    private

      def fetch_friend_ids_all!
        while !@next_cursor.zero?
          friends = twitter_rest_client.friend_ids(twitter_id, cursor: @next_cursor)
          @friend_ids += friends.attrs[:ids]
          @next_cursor = friends.attrs[:next_cursor]
        end
      end

      def twitter_id
        @twitter_id ||= User.find(@user_id).twitter_id
      end

      def twitter_rest_client
        @twitter_rest_client ||= TwitterRestClient.by_user_id(@user_id)
      end
  end
end

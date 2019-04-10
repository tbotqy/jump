# frozen_string_literal: true

class TwitterRestClient
  class << self
    def by_user_id(user_id)
      user = User.find(user_id)
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Settings.twitter.consumer_key
        config.consumer_secret     = Settings.twitter.consumer_secret_key
        config.access_token        = user.token
        config.access_token_secret = user.token_secret
      end
    end
  end
end

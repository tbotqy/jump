class TwitterRestClient
  class << self
    def by_user_id(user_id)
      user = User.find(user_id)
      Twitter::REST::Client.new do |config|
        config.consumer_key        = configatron.consumer_key
        config.consumer_secret     = configatron.consumer_secret
        config.access_token        = user.token
        config.access_token_secret = user.token_secret
      end
    end
  end
end

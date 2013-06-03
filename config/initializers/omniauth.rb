Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, configatron.twitter.consumer_key, configatron.twitter.consumer_secret
end

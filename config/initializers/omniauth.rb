Rails.application.config.middleware.use OmniAuth::Builder do
  # delegate to devise
  # provider :twitter, configatron.consumer_key, configatron.consumer_secret
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, configatron.consumer_key, configatron.consumer_secret
end

Twitter.configure do |config|
  config.consumer_key = configatron.consumer_key
  config.consumer_secret = configatron.consumer_secret
  config.connection_options = Twitter::Default::CONNECTION_OPTIONS.merge(:request => { 
      :open_timeout => 60,
      :timeout => 60
    })
end

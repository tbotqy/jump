class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_vars

  def set_vars
    # set vars only if reqeust is not Ajax
    unless request.xhr?
      # implement later
      @show_footer = true
      @logged_in = false
      @user_is_initialized = false
      @logging_user = false
    end
  end
  
  def create_twitter_client(access_token = nil, access_token_secret = nil)
    
    if !access_token || !access_token_secret
      # load keys from database
      user = User.find(session[:user_id])
      access_token = user.token
      access_token_secret = user.token_secret
    end

    Twitter.configure do |config|
      config.consumer_key = configatron.consumer_key
      config.consumer_secret = configatron.consumer_secret_key
      config.oauth_token = access_token
      config.oauth_token_secret = access_token_secret
    end
    
    return @twitter_client = Twitter::Client.new
  end

end

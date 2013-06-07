class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :set_vars
  
  @@current_user = nil

  def set_vars
    @logged_in = logged_in?
    @@current_user ||= User.find(session[:user_id]) if session[:user_id]
    @show_footer = false
    @current_user = @@current_user
  end
  
  def check_login
    unless @logged_in 
      redirect_to root_url
    else
      return true
    end
  end

  def check_tweet_import
    if check_login
      unless User.find(session[:user_id]).has_imported?
        redirect_to :controller => "statuses", :action => "import"
      end
    end
  end
  
  def logged_in?
    session[:user_id] ? true : false
  end

  def create_twitter_client
    user = User.find(session[:user_id])
    
    # user = User.find(@@current_user.id)
    access_token = user.token
    access_token_secret = user.token_secret
    
    Twitter.configure do |config|
      config.consumer_key = configatron.consumer_key
      config.consumer_secret = configatron.consumer_secret
      config.oauth_token = access_token
      config.oauth_token_secret = access_token_secret
    end
    
    Twitter::Client.new
  end

end

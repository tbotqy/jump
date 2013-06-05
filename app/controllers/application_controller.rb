class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_vars
  
  def set_vars

    # set vars only if request is not Ajax
    unless request.xhr?
      @logged_in = logged_in?
      @current_user = @logged_in ? User.find(session[:user_id]) : false
      @show_footer = false
    end
    
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
    session[:user_id]
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
    
    @twitter_client = Twitter::Client.new
  end

end

class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :set_vars, :apply_user_time_zone
  
  def set_vars
    @@current_user = get_current_user || nil
    @@user_id = @@current_user ? @@current_user.id : nil
    @show_footer = false
    @current_user = @@current_user
  end

  def apply_user_time_zone
    if @@current_user
      Time.zone = @@current_user.time_zone
    end
  end
  
  def check_login
    unless logged_in? 
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
  
  def get_current_user
    User.find(session[:user_id]) if logged_in?
  end

  def logged_in?
    session[:user_id] ? true : false
  end

  def create_twitter_client
    user = @current_user || User.find(session[:user_id])
    Twitter.configure do |config|
      config.consumer_key = configatron.consumer_key
      config.consumer_secret = configatron.consumer_secret
      config.oauth_token = user.token
      config.oauth_token_secret = user.token_secret
    end
    Twitter::Client.new
  end

  def fetch_friend_list_by_twitter_id(twitter_id)
    # fetch friend list from twitter
    ret = []
    next_cursor = -1
    while next_cursor != 0
      # fetch all the frined ids from twitter
      obj_friends = create_twitter_client.friend_ids(twitter_id,{:cursor => next_cursor})
      ret += obj_friends.attrs[:ids]
      next_cursor = obj_friends.attrs[:next_cursor]
    end
    ret
  end

end

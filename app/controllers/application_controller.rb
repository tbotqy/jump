# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :reject_incompatible_ua, :set_vars, :apply_user_time_zone
  include Jpmobile::ViewSelector

  # handlers for exceptions
  if Rails.env.production?
    rescue_from Exception, :with => :render_500
  end
  
  def render_404(exception = nil)
    @title = "ページが見つかりません"
    @show_footer = true
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    render :file => "errors/404", :status => 404, :layout => "error", :content_type => 'text/html'
  end

  def render_500(exception = nil)
    @title = "サーバーエラー"
    @show_footer = true
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    render :file => "errors/500", :status => 500, :layout => "error", :content_type => 'text/html'
  end

  def is_available_ua?
    # reject msie whose version is not 9
    ua = request.env['HTTP_USER_AGENT'].to_s
    if ua.include?("MSIE")
      # check its version
      return false unless ua.include?("9.0")
    end
    true
  end
  
  def reject_incompatible_ua

    if request.xhr? then return true end
    if params[:action] == "browsers" then return true end
    
    unless is_available_ua?
      redirect_to :controller => "users", :action => "browsers"
    end
  end
  
  def set_vars
    @@current_user = get_current_user || nil
    @@user_id = @@current_user ? @@current_user.id : nil

    @show_header = true
    @show_footer = false
    @show_scrollbar = false
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
    if logged_in?
      User.find(session[:user_id]) rescue redirect_to :controller => "logs", :action => "logout"
    end
  end

  def logged_in?
    session[:user_id] ? true : false
  end

  def create_twitter_client(access_token = nil,access_token_secret = nil)
    user = @current_user || User.find(session[:user_id])
    Twitter.configure do |config|
      config.consumer_key = configatron.consumer_key
      config.consumer_secret = configatron.consumer_secret
      config.oauth_token = access_token || user.token
      config.oauth_token_secret = access_token_secret || user.token_secret
      config.connection_options = Twitter::Default::CONNECTION_OPTIONS.merge(:request => { 
          :open_timeout => 60,
          :timeout => 60
        })
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

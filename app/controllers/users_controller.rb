class UsersController < ApplicationController

  before_filter :check_login, :except => ["index","callback"]
  before_filter :check_tweet_import, :except => ["index","callback"]

  def index

    # check if user is logged in
    if @logged_in
      redirect_to :action => "home_timeline"
    else
      @show_footer = true
      @total_status_num = Status.get_total_status_num
    end

  end
  
  def callback
    # called when user was redirected back to our service from twitter.com

    # read acquired access tokens
    auth = request.env['omniauth.auth']

    # check whether user's twitter account is protected
    if auth.extra.raw_info.protected
      render :file => "/shared/_we_are_sorry" and return
    end

    # check if tokens are acquired correctly
    access_token = auth.credentials.token
    access_token_secret = auth.credentials.secret
    
    if !access_token
      abort("failed in acquiring access token")
    end

    # check if user already exists
    if User.twitter_id_exists?(auth.uid)
      # update account with auth
      User.update_account(auth)
    else
      # create new account
      User.create_account(auth)
    end

    # log the user in
    redirect_to :controller => "logs", :action => "login"
    
  end

  def home_timeline
    raise "welcome!"
  end

end

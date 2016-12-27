class LogsController < ApplicationController

  def login
    # called when user was redirected back to our service from twitter.com

    # read acquired access tokens
    auth = request.env['omniauth.auth']

    # check whether user's twitter account is protected
    if Rails.env.production? and auth.extra.raw_info.protected
      redirect_to :action => "sorry" and return
    end

    # check if tokens are acquired correctly
    access_token = auth.credentials.token
    access_token_secret = auth.credentials.secret

    if !access_token
      abort("failed in acquiring access token")
    end

    # check if user already exists
    if User.active_twitter_id_exists?(auth.uid)
      # update account with auth
      User.update_account(auth)
    else
      # create new account
      User.create_account(auth)
    end

    # log the user in
    session[:user_id] = User.select(:id).where("twitter_id = ? AND deleted_flag = false",auth.uid)[0].id

    # check if user has imported own tweets
    unless User.find(session[:user_id]).has_imported?
      redirect_to :controller => "statuses", :action => "import"
    else
      redirect_to root_url
    end

  end

  def logout
    reset_session
    redirect_to root_url
  end

  def sorry
    @show_footer = true
  end

end

class SessionController < ApplicationController
  before_filter :reject_protected_user!, only: :login

  def login

    # called when user was redirected back to our service from twitter.com

    # check if tokens are acquired correctly
    access_token = auth.credentials.token
    access_token_secret = auth.credentials.secret

    if !access_token
      abort("failed in acquiring access token")
    end

    # check if user already exists
    if User.active_twitter_id_exists?(auth.uid)
      # update account with auth
      User.update_account!(auth)
    else
      # create new account
      User.create_account!(auth)
    end

    # log the user in
    session[:user_id] = User.select(:id).where("twitter_id = ? AND deleted_flag = false",auth.uid)[0].id

    # check if user has imported own tweets
    unless User.find(session[:user_id]).has_imported?
      redirect_to :controller => "statuses", :action => "import"
    else
      redirect_to controller: :statuses, action: :sent_tweets
    end

  end

  def logout
    reset_session
    redirect_to root_url
  end

  private

  # check whether user's twitter account is protected
  def reject_protected_user!
    return unless Rails.env.production?
    return unless auth.extra.raw_info.protected
    redirect_to controller: :pages, action: :sorry
  end

  # read acquired access tokens
  def auth
    @auth ||= request.env['omniauth.auth']
  end
end

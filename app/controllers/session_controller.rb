class SessionController < ApplicationController
  before_filter :reject_protected_user!,       only: :login
  before_filter :check_if_tokens_are_present!, only: :login

  # called when user was redirected back to our service from twitter.com
  def login
    User.register_or_update!(auth)

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

  # check if tokens are acquired correctly
  def check_if_tokens_are_present!
    return if [auth.credentials.token, auth.credentials.secret].all?
    raise "failed in acquiring access token"
  end

  # read acquired access tokens
  def auth
    @auth ||= request.env['omniauth.auth']
  end
end

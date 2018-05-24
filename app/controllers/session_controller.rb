class SessionController < ApplicationController
  before_action :reject_protected_user!,       only: :login
  before_action :check_if_tokens_are_present!, only: :login

  # called when user was redirected back to our service from twitter.com
  def login
    User.register_or_update!(auth)
    user = User.find_active_with_auth(auth)
    login!(user)
    return redirect_to controller: :statuses, action: :user_timeline if user.finished_initial_import?
    redirect_to controller: :statuses, action: :import
  end

  def logout
    logout!
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

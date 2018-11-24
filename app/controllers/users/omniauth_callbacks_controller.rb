class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    User.register_or_update!(auth)
    user = User.find_active_with_auth(auth)
    sign_in user
    return redirect_to controller: :statuses, action: :user_timeline if user.finished_initial_import?
    redirect_to controller: :statuses, action: :import
  end

  private

  # read acquired access tokens
  def auth
    @auth ||= request.env['omniauth.auth']
  end
end

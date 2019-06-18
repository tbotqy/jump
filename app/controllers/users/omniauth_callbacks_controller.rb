# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    user = User.register_or_update!(user_params)
    sign_in user

    if user.finished_initial_import?
      redirect_to user_timeline_path
    else
      redirect_to status_import_path
    end
  rescue => e
    # rescue the exception explicitly to unify the behavior between the environments
    Raven.capture_exception(e)
    head 500
 end

  # this methods is called when the user declined to authorize our app
  def failure
    redirect_to sign_out_path
  end

  private

    delegate :provider,
             :uid,
             to: :auth

    delegate :created_at,
             :name,
             :screen_name,
             :protected,
             :profile_image_url_https,
             to: :auth_raw_info

    delegate :token,
             :secret,
             to: :auth_credentials

    def user_params
      {
        provider:           provider,
        uid:                uid,
        twitter_id:         uid.to_i,
        twitter_created_at: created_at,
        name:               name,
        screen_name:        screen_name,
        protected:          protected,
        profile_image_url_https: profile_image_url_https,
        token:              token,
        token_secret:       secret
      }
    end

    def auth
      @auth ||= request.env["omniauth.auth"]
    end

    def auth_raw_info
      @auth_raw_info ||= auth.extra.raw_info
    end

    # memo: not using #delegate in order to unify the level of delegations in this class
    def auth_credentials
      @auth_credentials ||= auth.credentials
    end
end
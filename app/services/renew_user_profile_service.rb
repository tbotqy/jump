# frozen_string_literal: true

class RenewUserProfileService
  include UserTwitterClient
  private_class_method :new

  class << self
    def call!(user_id:)
      new(user_id).send(:call!)
    end
  end

  private
    def initialize(user_id)
      @user_id = user_id
    end

    attr_reader :user_id

    def call!
      fetch_fresh_data
      user.update!(
        name:           @user_info.name,
        screen_name:    @user_info.screen_name,
        protected_flag: @user_info.protected?,
        avatar_url:     @user_info.profile_image_url_https.to_s
      )
    end

    def fetch_fresh_data
      @user_info = user_twitter_client.twitter_user
    end

    def user
      @user ||= User.find(user_id)
    end
end

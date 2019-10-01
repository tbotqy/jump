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
      ActiveRecord::Base.transaction do
        update_user!
        update_user_statuses!
      end
    end

    def fetch_fresh_data
      @user_info = user_twitter_client.twitter_user
    end

    def update_user!
      user.update!(
        name:           @user_info.name,
        screen_name:    @user_info.screen_name,
        protected_flag: @user_info.protected?,
        avatar_url:     @user_info.profile_image_url_https.to_s,
        profile_banner_url: @user_info.profile_banner_url_https(Settings.banner_size)
      )
    end

    def update_user_statuses!
      user.statuses.update_all(protected_flag: @user_info.protected?, updated_at: Time.current)
    end

    def user
      @user ||= User.find(user_id)
    end
end

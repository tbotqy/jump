# frozen_string_literal: true

class UpdateUserAccountService
  private_class_method :new

  class << self
    def call!(user_id:)
      new(user_id).send(:call!)
    end
  end

  private
    def initialize(user_id)
      @user_id = user_id
      fetch_fresh_data!
    end

    def call!
      target_user.update!(
        name:        @user_info.name,
        screen_name: @user_info.screen_name,
        protected_flag: @user_info.protected?,
        profile_image_url_https: @user_info.profile_image_url_https.to_s
      )
    end

  private
    def fetch_fresh_data!
      client = TwitterRestClient.by_user_id(@user_id)
      @user_info    = client.user
      @setting_info = client.settings
    end

    def target_user
      User.find(@user_id)
    end
end

class UpdateUserAccountService
  private_class_method :new

  class << self
    def call!(target_user_id)
      new(target_user_id).send(:call!)
    end
  end

  private

  def initialize(target_user_id)
    @target_user_id = target_user_id
    fetch_fresh_data!
  end

  def call!
    target_user.update!(
      name:        @user_info.name,
      screen_name: @user_info.screen_name,
      protected:   @user_info.protected?,
      profile_image_url_https: @user_info.profile_image_url_https.to_s,
      time_zone:   @setting_info.time_zone[:name],
      utc_offset:  @setting_info.time_zone[:utc_offset],
      lang:        @user_info.lang
    )
  end

  private

  def fetch_fresh_data!
    client = TwitterRestClient.by_user_id(@target_user_id)
    @user_info    = client.user
    @setting_info = client.settings
  end

  def target_user
    User.find(@target_user_id)
  end
end

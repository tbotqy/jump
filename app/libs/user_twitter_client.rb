# frozen_string_literal: true

module UserTwitterClient
  def user_twitter_client
    @user_twitter_client ||= TwitterClient.new(access_token: access_token, access_token_secret: access_token_secret)
  end

  private
    delegate :access_token, :access_token_secret, to: :user

    def user
      raise "define me"
    end
end

# frozen_string_literal: true

module UserTwitterClient
  def user_twitter_client
    @user_twitter_client ||= TwitterClient.new(user_id: user.id)
  end

  private
    def user
      raise "define me"
    end
end

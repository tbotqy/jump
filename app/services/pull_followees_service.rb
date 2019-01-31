class PullFolloweesService
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

  def call!
    if difference_exists?
      delete_and_register!
    else
      update_timestamp!
    end
  end

  def delete_and_register!
    FollowingTwitterId.user_id(@user_id).delete_all
    FollowingTwitterId.register!(@user_id, fresh_friend_twitter_ids)
  end

  def update_timestamp!
    User.find(@user_id).update_attribute(:friends_updated_at, Time.now.utc.to_i)
  end

  private

  def difference_exists?
    existing_friend_twitter_ids != fresh_friend_twitter_ids
  end

  def existing_friend_twitter_ids
    @existing_friend_twitter_ids ||= FollowingTwitterId.user_id(@user_id).pluck(:following_twitter_id).sort
  end

  def fresh_friend_twitter_ids
    @fresh_friend_twitter_ids ||= TwitterServiceClient::Friend.fetch_friend_twitter_ids(user_id: @user_id).sort
  end
end

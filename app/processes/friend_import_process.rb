class FriendImportProcess
  class << self
    def initial_import!(user_id)
      new(user_id).import!
    end

    def update!(user_id)
      new(user_id).update!
    end
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def import!
    FollowingTwitterId.register!(@user_id, fresh_friend_twitter_ids)
  end

  def update!
    if difference_exists?
      FollowingTwitterId.user_id(@user_id).delete_all
      import!
    else
      # just update timestamp
      User.find(@user_id).update_attribute(:friends_updated_at, Time.now.utc.to_i)
    end
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

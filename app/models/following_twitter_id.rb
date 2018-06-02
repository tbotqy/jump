class FollowingTwitterId < ApplicationRecord
  belongs_to :user

  class << self
    def get_friend_user_ids(user_id)
      # returns the array of friends' user_ids

      # retrieve twitter ids
      following_twitter_ids = get_friend_twitter_ids(user_id)

      # retrieve user ids by twitter ids
      user_ids = User.where("twitter_id IN (?)",following_twitter_ids).pluck(:id)
    end

    def get_friend_twitter_ids(user_id)
      # returns the array of friends' twitter id
      select(:following_twitter_id).where(user_id: user_id).pluck(:following_twitter_id)
    end


    def save_friends(user_id, friend_ids)
      created_at = Time.now.to_i

      friend_ids.each do |fid|
        create(
          user_id: user_id,
          following_twitter_id: fid,
          created_at: created_at
        )
      end

      # update the time stamp in User model
      User.find(user_id).update_attribute(:friends_updated_at, created_at)
    end

    def update_list(user_id, friend_ids)
      # delete user's friend list
      where(user_id: user_id).destroy_all
      # insert new friend list
      save_friends(user_id, friend_ids)
    end
  end
end

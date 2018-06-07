class FollowingTwitterId < ApplicationRecord
  belongs_to :user
  scope :user_id, ->(user_id){where(user_id: user_id)}

  class << self
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
  end
end
